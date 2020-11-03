'''
Query REST api for PDC files of interest
Saves them to local data directory
'''
import requests
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from scipy.stats import zscore


def query_pdc(query):
    '''
    Primary query functionality from PDC website
    '''
    # PDC API url
    url = 'https://pdc.cancer.gov/graphql'
    # Send the POST graphql query
    print('Sending query.')
    pdc_response = requests.post(url, json={'query': query})
    # Check the results
    if pdc_response.ok:
       # Decode the response
        return pdc_response.json()
    else:
        # Response not OK, see error
        return pdc_response.raise_for_status()

#prot_only = [a for a in studies if ' Proteome' in a]

########get metadata

def get_all_metadata(sublist):
    df_list = []
    for study_submitter_id in sublist:
        print(study_submitter_id)

        metadata_query = '''
        {
        biospecimenPerStudy(pdc_study_id: "''' + study_submitter_id + '''")  {
        aliquot_submitter_id
        project_name
        case_submitter_id
        sample_type
        disease_type
        }
        }
        '''
        decoded = query_pdc(metadata_query)
        #print(decoded)
        matrix = decoded['data']['biospecimenPerStudy']
        #print(matrix)
        if len(matrix)== 0:
            continue
        metadata = pd.DataFrame(matrix, columns=matrix[0]).set_index('aliquot_submitter_id')
        df_list.append(metadata)
    return pd.concat(df_list)

########get data matrices for each study

def getSampleDataMatrix(sub_list):
    '''
    Creates query for each item in list
    '''
    data_type = 'unshared_log2_ratio'  # Retrieves CDAP iTRAQ or TMT data
    mat_list=[]
    for sub in sub_list:
        print(sub)
        exp_data_query = '''        {
        quantDataMatrix(
        pdc_study_id: "'''+sub+'''" data_type: "''' + data_type + '''"
        )
        }'''
        decoded = query_pdc(exp_data_query)
        #print(decoded)
        matrix = decoded['data']['quantDataMatrix']
        if matrix is None or len(matrix)== 0:
            continue
        ga = pd.DataFrame(matrix[1:], columns=matrix[0]).set_index('Gene/Aliquot')
        print(ga.shape)
        mat_list.append(ga)
    return pd.concat(mat_list, axis=1)


def compute_matched_tumor_normal(metadata, sampdata):
    '''
    Finds matched samples in metdadta and computes
    tumor-normal log fold change values
    '''
    tum_types = set(metadata['disease_type']).difference(set(['Other']))
    samp_names = [k.split(':')[1] for k in sampdata.columns]
    dis_dict = {}
    for tum in tum_types:
        #print("Collecting",tum,"samples")
        #get normal and tumor cases out of metadata
        tum_met = metadata[metadata['disease_type']==tum]
        norm_cases = tum_met['case_submitter_id']\
            [tum_met.sample_type.isin(['Solid Tissue Normal', 'Normal'])]
        tum_cases = tum_met['case_submitter_id']\
            [tum_met.sample_type.isin(['Tumor', 'Primary Tumor'])]
        #collect all the column indices for the disease
        lfc_list = []
        if(len(norm_cases)==0):
           # print("No normal cases for",tum)
            continue
        for n in norm_cases:
            norm_cols = []
            tum_cols = []
           # print(n)
            for i in norm_cases[norm_cases==n].index:
                norm_cols.append(i)
            for i in tum_cases[tum_cases==n].index:
                tum_cols.append(i)
            ##create two matrices, one tumor, one normal, and subtract? will that work?
            if(len(tum_cols)==0 or len(norm_cols)==0):
              #  print("No tumor/normal samples found for",tum)
                continue
            tum_vals = [pd.to_numeric(sampdata.iloc[:, samp_names.index(i)], errors='coerce') for i in tum_cols if i in samp_names]
            if(len(tum_vals)==0):
             #   print("Could not find tumor samples for",n)
                continue
            tum_means = pd.concat(tum_vals, axis=1).mean(axis=1)
            norm_vals  = [pd.to_numeric(sampdata.iloc[:, samp_names.index(i)], errors='coerce') for i in norm_cols if i in samp_names]
            if(len(norm_vals)==0):
             #   print("Could not find normal values for",n)
                continue
            norm_means = pd.concat(norm_vals, axis=1).mean(axis=1)
            lfc = pd.DataFrame({'logRatio':(tum_means - norm_means)})
           # print(lfc)
            lfc = lfc.dropna().reset_index().rename(columns={'index':'Gene'})
            lfc['Patient'] = n
            lfc_list.append(lfc)
        print("Found", len(lfc_list), 'tumor-matched lfcs for', tum)
        dis_dict[tum] = pd.concat(lfc_list,axis=0)
    return dis_dict

def compute_pooled_tumor_normal(metadata,sampdata):
    '''
    Matches only as far as the tumor type,
    pools normals across and computes individiaul LFC for
    each tumor
    '''
    tum_types = set(metadata['disease_type']).difference(set(['Other']))
    samp_names = [k.split(':')[1] for k in sampdata.columns]
    dis_dict = {}
    for tum in tum_types:
        #get normal and tumor cases out of metadata
        #print("Collecting",tum)
        tum_met = metadata[metadata['disease_type']==tum]
        norm_cases = tum_met['case_submitter_id']\
            [tum_met.sample_type.isin(['Solid Tissue Normal', 'Normal'])]
        tum_cases = tum_met['case_submitter_id']\
            [tum_met.sample_type.isin(['Tumor', 'Primary Tumor'])]
        #collect all the column indices for the disease
        norm_cols = [i for i in norm_cases.index]

        if(len(norm_cols)==0):
            #print("No normals for",tum)
            continue
        norm_vals = [pd.to_numeric(sampdata.iloc[:,samp_names.index(i)],\
                                              errors='coerce') for i in norm_cols if i in samp_names]
        if(len(norm_vals)==0):
            #print("Could not find _any_ normals for",tum)
            continue
        norm_means = pd.concat(norm_vals, axis=1).mean(axis=1)
        lfc_list = []
        for n in tum_cases:
            tum_cols = []
            for i in tum_cases[tum_cases==n].index:
                tum_cols.append(i)
            ##create two matrices, one tumor, one normal, and subtract? will that work?
            tum_vals = [pd.to_numeric(sampdata.iloc[:,samp_names.index(i)],\
                                                 errors='coerce') for i in tum_cols if i in samp_names]
            if(len(tum_vals)==0):
            #    print("Could not find tumor values for",n)
                continue
            tum_means = pd.concat(tum_vals, axis=1).mean(axis=1)
            lfc = pd.DataFrame({'logRatio':(tum_means - norm_means)})
          #  lfc = pd.DataFrame(lfc)
           # print(lfc)
            lfc = lfc.dropna().reset_index().rename(columns={'index':'Gene'})
            lfc['Patient'] = n
            lfc_list.append(lfc)
        print("Found", len(lfc_list), 'tumor-pooled lfcs for', tum)
        dis_dict[tum] = pd.concat(lfc_list, axis=0)
    return dis_dict

def query_all_studies():
    '''
    Queries all studies by a key-word
    The default is `Proteome`
    Returns a data frame of metadata and a data frame
    of log2 ratios
    '''

    study_query = '''
    {
    studySearch(
    name: "Proteome" ) {
    studies { record_type name submitter_id_name pdc_study_id} }
    }
    '''
    #first get all the studies
    decoded = query_pdc(study_query)
    studies = [x['pdc_study_id'] for x in decoded['data']['studySearch']['studies']\
               if ' Proteome' in x['submitter_id_name']]

    metadata = get_all_metadata(studies)
    #metadata.to_csv('allMet.csv')

    sampdata = getSampleDataMatrix(studies)
    #sampdata.to_csv('allSamps.csv')
    return metadata, sampdata

if __name__=='__main__':
    met, samp = query_all_studies()
    indiv = compute_matched_tumor_normal(met,samp)
    pooled = compute_pooled_tumor_normal(met,samp)
