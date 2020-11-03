#!/usr/local/bin/python
'''
Basic CLI to import CPTAC proteomic data
'''
import argparse
import cptac


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--cancerType', dest='type',\
                        help='Cancer type to be collected')
    opts = parser.parse_args()

    if opts.type.lower() == 'brca':
        dat = cptac.Brca()
    elif opts.type.lower() == 'ccrcc':
        dat = cptac.Ccrcc()
    elif opts.type.lower() == 'coad':
        dat = cptac.Colon()
    elif opts.type.lower() == 'ovca':
        dat = cptac.Ovarian()
    else:
        exit()
    df = dat.get_transcriptomics()
    df.to_csv(path_or_buf="file.tsv", sep='\t')

if __name__ == '__main__':
    main()
