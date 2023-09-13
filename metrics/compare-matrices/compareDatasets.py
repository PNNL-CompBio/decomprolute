'''
This script will compare datasets across the cptac module
'''


import cptac
import argparse
import pandas
import numpy as np
from plotnine import *
import os
import re


ctype = {'brca': 'Breast carcinoma','coad':'Colorectal adenocarcinoma','lscc':'Lung small cell carcinoma',\
         'luad':'Lung adenocarcinoma','gbm':'Glioblastoma multiforme','hnscc':'Head and neck squamous cell carcinoma',\
         'pdac':'Pancreatic ductal adenocarcinoma','ucec':'Uterine corpus endometrial carcinoma',\
         'ccrcc':'Clear cell renal cell carcinoma','ovarian':'Ovarian serous adenocarcimona'}

def get_counts(dat):
    # we have to add data source
    sources = dat.list_data_sources()
    psource = [row['Available sources'][0] for index,row in sources.iterrows() if row['Data type']=='proteomics']
    tsource = [row['Available sources'][0] for index,row in sources.iterrows() if row['Data type']=='transcriptomics']
    pdat=dat.get_proteomics(source=psource[0])
    tdat=dat.get_transcriptomics(source=tsource[0])

    ppats = set([p for p in pdat.index])
    tpats = set([t for t in tdat.index])
    over = set.intersection(ppats,tpats)
    res = {'Proteomics only':len(ppats)-len(over),'Transcriptomics only':len(tpats)-len(over),\
           'Proteomics and transcriptomics':len(over)}
    return res

def main():
    '''
    main input
    '''

    parser = argparse.ArgumentParser(description='compare signature matrix mrna/prot expression')
    args = parser.parse_args()

    ##now we get the cptac datasets from the package
    dslist = []
    for ds in ['brca', 'ccrcc', 'ucec', 'coad','pdac',
               'ovarian', 'luad', 'hnscc', 'gbm','lscc']:
        #cptac.download(dataset=ds)
        if ds == 'brca':
            dat = cptac.Brca()
        elif ds == 'ccrcc':
            dat = cptac.Ccrcc()
        elif ds == 'coad':
            dat = cptac.Coad()
        elif ds == 'ovarian':
            dat = cptac.Ov()
        elif ds == 'ucec':
            dat = cptac.Ucec()
        elif ds == 'hnscc':
            dat = cptac.Hnscc()
        elif ds == 'luad':
            dat = cptac.Luad()
        elif ds == 'gbm':
            dat = cptac.Gbm()
        elif ds == 'pdac':
            dat = cptac.Pdac()
        elif ds == 'lscc':
            dat = cptac.Lscc()
        else:
            exit()
            ##now get the data, create one large data frame
            #compute correlation
        res= get_counts(dat)
        res['Dataset']=ctype[ds]
        dslist.append(res)

    df = pandas.DataFrame(dslist)
    df = pandas.melt(df,id_vars='Dataset',value_vars=['Transcriptomics only','Proteomics and transcriptomics','Proteomics only'],\
                     var_name='Data type',value_name='Samples')
    ##now we can plot the statistics using the plotnine pacakge
    print(df.head())
    plot = (
        ggplot(df, aes(x='Dataset', col='Data type', fill='Data type', y='Samples'))
        + geom_bar(stat='identity',position='dodge')
        + xlab('Cancer type')
        + ylab("Number of samples")
        + theme(axis_text_x=element_text(rotation=90, hjust=1))
    )
    fname = 'cancer_data_types.pdf'
    plot.save(fname)



if __name__ == '__main__':
    main()
