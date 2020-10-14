"""
queryGDC.py
A simple script that uses the Genomic Data Commons API
to query for tumor somatic mutations for patients with specific TCGA case ids
@author sgosline

"""
import requests
import json
import pandas as pd
import re, os, glob
import gzip
import math
import pickle

#these are the various endpoints to query
ssms_endpt = "https://api.gdc.cancer.gov/ssm_occurrences"
printcnv_endpt = "https://api.gdc.cancer.gov/cnvs"
cases_endpt = 'https://api.gdc.cancer.gov/cases'
files_endpt = "https://api.gdc.cancer.gov/files"

#here are the cases we want to query
case_file = pd.read_csv('../hyphalnet/examples/cancerProtFeatures/data/PDC_clinical_manifest_07182020_150316.csv')
cases = list(case_file['Cases Submitter ID']) #read from CSV
gdc_list = list(case_file['External Case ID'])
cptac_dict = dict(zip(cases, gdc_list))#dict(zip(list(case_file['Case ID']), cases))

new_dict = {}
for key, val in cptac_dict.items():
    if isinstance(val, str):
        new_dict[key] = val.split(': ')[1]

print("Found GDC matches for", len(new_dict),\
      'samples out of', len(cptac_dict), 'PDC samples')

def getMAFfilesForCases(cases):
    """
    For a list of cases, select the MAF files
    """
    #now we start populating our query
    #need to get ssm ids of all values in cases
    filters = {
        "op": "and",
        "content":[
            {
                "op": "in",
                "content":{
                    "field": "cases.submitter_id",
                    "value": cases
                }
            },
            {
                "op": "in",
                "content":{
                    "field": "files.data_format",
                    "value": ["MAF"]
                }
            },
            {
                "op": "in",
                "content":{
                    "field": "files.analysis.workflow_type",
                    "value": ["Aliquot Ensemble Somatic Variant Merging and Masking"]
                }
            },
            {
                "op": "in",
                "content":{
                    "field": "files.data_type",
                    "value": ["Masked Somatic Mutation"]
                }
            }
        ]
    }
    #we only need a few fields
    fields = [
        "file_id",
        "submitter_id",
        "file_name"
    ]
    fields = ','.join(fields)
    params = {
        "filters": json.dumps(filters),
        "fields": fields,
        "format": "json",
        "size": len(cases)
}

    ##first we have to get the maf files to download
    response = requests.post(files_endpt,\
                             headers={"Content-Type": "application/json"},\
                             json=params)

    #print(response.content.decode("utf-8"))
    #need to get all cnv ids of all values in cases
    #now get the gene/sample mappings
    #put them back to CPTAC mappings
    data_endpt = "https://api.gdc.cancer.gov/data"
    ids = []
    for hit in json.loads(response.content)['data']['hits']:
        ids.append(hit['file_id'])

        #then we have to download the files
    params = {"ids": ids}
    response = requests.post(data_endpt,\
                             data=json.dumps(params),\
                             headers={
                                 "Content-Type": "application/json"
                             })
    response_head_cd = response.headers["Content-Disposition"]

    file_name = re.findall("filename=(.+)", response_head_cd)[0]
    with open(file_name, "wb") as output_file:
        output_file.write(response.content)
    print(file_name)
    return file_name

def getGenesFromMaf(maffile):
    """
    Get genes and mutational information out of maf file
    """

    maf_head = pd.read_csv(gzip.open(maffile),sep='\t',comment='#')
    ##get hugo_symbol, and case_id
    return maf_head[['Hugo_Symbol', 'case_id', 'HGVSc', 'One_Consequence', 'SIFT', 'PolyPhen']]



file_name = getMAFfilesForCases(cases)
##let's geta ll maf files
os.system('tar -xvzf '+file_name)

##then open all mafs
maf_files = glob.glob("*/*maf.gz")

#save as data frame, then as dictionary
all_dfs = [getGenesFromMaf(m) for m in maf_files]
full_muts = pd.concat(all_dfs)
full_muts.to_csv('allGDCmutations.csv')

pat_dict = {}
for key, val in new_dict.items():
    pat_dict[key] = full_muts[full_muts['case_id'] == val][['Hugo_Symbol', 'HGVSc',\
                                                         'One_Consequence',\
                                                         'PolyPhen']]

pickle.dump(pat_dict, open('patientMutations.pkl','wb'))

#remove all mafs
for maf in maf_files:
    os.system('rm '+maf)
    #remove all directories
    os.system('rmdir '+os.path.dirname(maf))

#remove original tar file
os.system('rm '+file_name)
