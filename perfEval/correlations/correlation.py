#!/usr/local/bin/python

import pandas as pd
import argparse


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--transcriptomics', dest='rnafile',
                        help='Deconvoluted matrix of transcriptomics data')
    parser.add_argument('--proteomics', dest='profile',
                        help='Deconvoluted matrix of proteomics data')
    parser.add_argument('--output', dest='output',
                        help='Output file for the correlation values')
    opts = parser.parse_args()

    rna = pd.read_csv(opts.rnafile, sep='\t')
    pro = pd.read_csv(opts.profile, sep='\t')

    rnaCols = list(rna.columns)
    proCols = list(pro.columns)
    if len(rnaCols) != len(proCols) or len(set(rnaCols + proCols)) != len(proCols):
        raise ValueError(
            "The colums of proteomics matrix and transcriptomics matrix are not the same")
    correlations = pd.Series([pro[sample].corr(rna[sample])
                              for sample in proCols])
    correlations.index = proCols
    correlations.to_csv(opts.output, sep='\t')


if __name__ == '__main__':
    main()
