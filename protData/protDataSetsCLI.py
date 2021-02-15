#!/usr/local/bin/python
'''
Basic CLI to import CPTAC proteomic data
'''
import argparse
import cptac
import numpy as np


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--cancerType', dest='type',
                        help='Cancer type to be collected')
    opts = parser.parse_args()

    if opts.type.lower() == 'brca':
        dat = cptac.Brca()
    elif opts.type.lower() == 'ccrcc':
        dat = cptac.Ccrcc()
    elif opts.type.lower() == 'colon':
        dat = cptac.Colon()
    elif opts.type.lower() == 'ovarian':
        dat = cptac.Ovarian()
    elif opts.type.lower() == 'endometrial':
        dat = cptac.Endometrial()
    elif opts.type.lower() == 'hnscc':
        dat = cptac.Hnscc()
    elif opts.type.lower() == 'luad':
        dat = cptac.Luad()
    else:
        exit()
    df = dat.get_proteomics()
    # some dataset has two level of indices some has only one
    if df.columns.nlevels == 2:
        df.columns = df.columns.droplevel(1)
    elif df.columns.nlevels != 1:
        print("The number of column levels is larger not 1 or 2!\n")
        raise
    dfE = np.exp(df)
    dfU = np.log(dfE.sum(axis=1, level=0, min_count=1))
    dfU.transpose().to_csv(path_or_buf="file.tsv", sep='\t')


if __name__ == '__main__':
    main()
