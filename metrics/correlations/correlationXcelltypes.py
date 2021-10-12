#!/usr/local/bin/python

import pandas as pd
import argparse


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--transcriptomics', dest='rnafile',
                        help='Deconvoluted matrix of transcriptomics data')
    parser.add_argument('--proteomics', dest='profile',
                        help='Deconvoluted matrix of proteomics data')
    parser.add_argument('--spearOrPears', dest='sop', help='Use spearman or pearson correlation',
                        default='pearson')
    # parser.add_argument('--output', dest='output',
    #                     help='Output file for the correlation values')
    opts = parser.parse_args()

    rna = pd.read_csv(opts.rnafile, sep='\t', index_col=0)
    pro = pd.read_csv(opts.profile, sep='\t', index_col=0)

    rnaCols = list(rna.columns)
    proCols = list(pro.columns)
    rnaRows = list(rna.index)
    proRows = list(pro.index)
    intersectCols = list(set(rnaCols) & set(proCols))
    intersectRows = list(set(rnaRows) & set(proRows))

    pro = pro.loc[intersectRows, intersectCols]
    rna = rna.loc[intersectRows, intersectCols]

    rna = rna.transpose()
    pro = pro.transpose()

    if opts.sop == 'pearson':
        corrList = [pro[sample].corr(rna[sample]) for sample in intersectRows]
    else:
        corrList = [pro[sample].corr(rna[sample], method='spearman')
                    for sample in intersectRows]

    correlations = pd.Series(corrList)
    correlations.index = intersectRows
    correlations.to_csv("corrXcelltypes.tsv", sep='\t', header=False)


if __name__ == '__main__':
    main()
