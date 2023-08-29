'''
This script will take in a signature matrix and evaluate its expression across
all cancers available
'''


import cptac
import argparse
import pandas
import numpy as np
from plotnine import *
import os
import re


def get_cor_stat(dat, prot_markers):
    '''
    This function takes an mrna and protein matrix and compares
    the correlation of the entitites for a subset of proteins
    '''

    # we have to add data source
    sources = dat.list_data_sources()
    psource = [row['Available sources'].split(',')[0] for index,row in sources.iterrows() if row['Data type']=='proteomics']
    tsource = [row['Available sources'].split(',')[0] for index,row in sources.iterrows() if row['Data type']=='transcriptomics']
    genes = [p for p in prot_markers['NAME']]
    #get the merged data frame from cptac data
    merged = dat.join_omics_to_omics(df1_name='proteomics', \
                                     df2_name='transcriptomics', \
                                     df1_source=psource[0],\
                                     df2_source=tsource[0],\
                                     genes1=genes, genes2=genes)
    if merged.columns.nlevels == 2:
        merged.columns = merged.columns.droplevel(1)

    #get proteins and transcripts
    prots = merged.loc[:, merged.columns.str.contains('proteomics')]

    prots['Name'] = prots.index
    prots = prots.melt(id_vars="Name", var_name='id', value_name='prot')
    prots['Gene'] = prots['id'].str.split('_', expand=True)[0]
    prots = prots.drop('id',axis=1)
    
    trans = merged.loc[:, merged.columns.str.contains('transcriptomics')]
    trans['Name'] = trans.index
    trans = trans.melt(id_vars="Name", var_name='id', value_name='trans')
    trans['Gene'] = trans['id'].str.split('_', expand=True)[0]
    trans=trans.drop('id',axis=1)

    #remerge the proteins and transcripts and compute spearman rank correlation
    both_df = pandas.merge(prots, trans, how='inner', left_on=['Name', 'Gene'],\
                           right_on=['Name', 'Gene'])
    corvals = both_df[['Gene', 'prot', 'trans']].groupby('Gene').corr('spearman').unstack()['trans']['prot']
    corvals = pandas.DataFrame(corvals)
    corvals["NAME"] = corvals.index
    #print(corvals.head())
    #print(prot_markers.head())
    ##merge back with protein markers
    full_df = corvals.reset_index().merge(prot_markers)[['Gene', 'prot', 'cell_type']]

    #return data frame of proteins by cell type
    return full_df

def get_na_counts(dat, prot_markers):
    '''
    we also want to see how many values are missing between mRNA and protein

    '''
    # we have to add data source
    sources = dat.list_data_sources()
    psource = [row['Available sources'].split(',')[0] for index,row in sources.iterrows() if row['Data type']=='proteomics']
    tsource = [row['Available sources'].split(',')[0] for index,row in sources.iterrows() if row['Data type']=='transcriptomics']
    genes = [p for p in prot_markers['NAME']]
    #get the merged data frame from cptac data
    merged = dat.join_omics_to_omics(df1_name='proteomics', \
                                     df2_name='transcriptomics', \
                                     df1_source=psource[0],\
                                     df2_source=tsource[0],\
                                     genes1=genes, genes2=genes)

    if merged.columns.nlevels == 2:
        merged.columns = merged.columns.droplevel(1)

    sums = merged.isna().sum()/merged.shape[0]
    inds = sums.index.str.split('_', expand=False)
    sumtab = pandas.DataFrame({'NAs':sums, 'NAME': [i[0] for i in inds], 'Data': [i[2] for i in inds]})

    counts = sumtab.merge(prot_markers).groupby(['cell_type', 'Data']).mean("NAs")
    return counts

def main():
    '''
    main input
    '''

    parser = argparse.ArgumentParser(description='compare signature matrix mrna/prot expression')
    parser.add_argument('--matrix', dest='matrix', help='matrix file to compare')
    args = parser.parse_args()

    ##first we get the matrix into shape
    matrix = pandas.read_csv(args.matrix, sep='\t')
    #print(matrix.columns)
    if 'Gene symbol' in matrix.columns:
        matrix = matrix.rename(columns={'Gene symbol':'NAME'})
    elif 'gene' in matrix.columns:
        matrix = matrix.rename(columns={'gene':'NAME'})

    matrix = matrix.melt(id_vars='NAME', var_name='cell_type', value_name='weight')

    max_weights = matrix.groupby('NAME').max('weight')
    matrix = matrix.join(max_weights, on='NAME', rsuffix='max')
    prot_markers = matrix.loc[matrix['weight'] == matrix['weightmax']]

    ##now we get the cptac datasets from the package
    dslist = {}
    countlist = {}
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
        dslist[ds] = get_cor_stat(dat, prot_markers)
        dslist[ds]['Tumor'] = ds
        countlist[ds] = get_na_counts(dat, prot_markers)
        countlist[ds]['Tumor'] = ds


    mval= os.path.splitext(os.path.basename(args.matrix))[0]
    #then plot cor values by cell type and cancer type
    fulltab = pandas.concat([dslist[d] for d in dslist.keys()])
    fulltab['Tumor'] = fulltab.Tumor.astype('category')
    fulltab['cell_type'] = fulltab.cell_type.astype('category')
    fulltab['sigMatrix'] = mval
    fulltab.to_csv(mval+'_allCors.csv')


    ##now we can plot the statistics using the plotnine pacakge
    print(fulltab.head())
    plot = (
        ggplot(fulltab, aes(x='cell_type', col='Tumor', fill='Tumor', y='prot', alpha=0.5))
        + geom_jitter(width=0.3)
        + geom_boxplot()
        + xlab('Cell Type')
        + ylab("Spearman rank correlation")
        + theme(axis_text_x=element_text(rotation=90, hjust=1))
    )
    fname = mval+'_sigMatrix_box_and_points.pdf'
    plot.save(fname)

    plot = (
        ggplot(fulltab, aes(x='cell_type', fill='Tumor', y='prot'))
        + geom_boxplot(alpha=0.5)
        + xlab('Cell Type')
        + ylab("Spearman rank correlation")
        + theme(axis_text_x=element_text(rotation=90, hjust=1))
        )
    fname = mval+'_sigMatrix_boxplot.pdf'
    plot.save(fname, height=8, width=10)

    counttab = pandas.concat([countlist[d] for d in countlist.keys()])
    counttab['SigMatrix']=mval
    print(counttab.head())
    counttab.to_csv(mval+'_allNAs.csv')
    counttab = pandas.read_csv(mval+'_allNAs.csv')
    plot = (
        ggplot(counttab, aes(x='cell_type', fill='Tumor', y='NAs'))
        + geom_bar(stat='identity', position='dodge')
        + facet_grid('Data ~.')
        + xlab('Cell Type')
        + ylab("Fraction missing data")
        + theme(axis_text_x=element_text(rotation=90, hjust=1))
    )
    fname = mval+'_nacounts_bar.pdf'
    plot.save(fname)
    plot = (
        ggplot(counttab, aes(x='cell_type', fill='Data', y='NAs'))
        + geom_boxplot(position='dodge')
        + xlab('Cell Type')
        + ylab("Fraction missing data")
        + theme(axis_text_x=element_text(rotation=90, hjust=1))
    )
    fname = mval+'_nacounts_box.pdf'
    plot.save(fname)


if __name__ == '__main__':
    main()
