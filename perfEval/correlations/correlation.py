#!/usr/local/bin/python

import pandas as pd
import argparse


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--transcriptomics', dest='rnafile',
                        help='Deconvoluted matrix of transcriptomics data')
    parser.add_argument('--proteomics', dest='profile',
                        help='Deconvoluted matrix of proteomics data')
    # parser.add_argument('--output', dest='output',
    #                     help='Output file for the correlation values')
    opts = parser.parse_args()

    rna = pd.read_csv(opts.rnafile, sep='\t', index_col=0)
    pro = pd.read_csv(opts.profile, sep='\t', index_col=0)

    rnaCols = list(rna.columns)
    proCols = list(pro.columns)
    intersected = list(set(rnaCols) & set(proCols))
    if len(rnaCols) != len(proCols) or len(intersected) != len(proCols):
        print(
            "The colums of proteomics matrix and transcriptomics matrix are not the same!\n")
    rna = rna[intersected]
    pro = pro[intersected]
    rnaCols = list(rna.columns)
    proCols = list(pro.columns)
    corrList = [pro[sample].corr(rna[sample]) for sample in proCols]
    correlations = pd.Series(corrList)
    correlations.index = proCols
    correlations.to_csv("corr.tsv", sep='\t', header=False)


if __name__ == '__main__':
    main()
