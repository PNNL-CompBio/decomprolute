#!/usr/local/bin/python
'''
Basic CLI to import CPTAC proteomic data
'''
import argparse
#import cptac
import pandas


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--cancerType', dest='type',
                        help='Cancer type to be collected')
    parser.add_argument('--sampleType', dest='sample', default='all',
                        help='Sample type, tumor vs normal vs all (default), \
                        to be collected')
    opts = parser.parse_args()

    df=pandas.read_csv("/data/"+opts.type+'.csv',index_col=0)
    
    # Get the sample type specific dataframe
    # if opts.sample.lower() != 'all':
    #     meta = dat.get_clinical()
    #     if opts.sample.lower() == 'tumor':
    #         ind = meta[meta["Sample_Tumor_Normal"] == "Tumor"].index
    #         ind = [i for i in ind if i in df.index]
    #         df = df.loc[ind]
    #     elif opts.sample.lower() == 'normal':
    #         nIDs = list(meta[meta["Sample_Tumor_Normal"] == "Normal"].index)
    #         nIDs = list(set(nIDs) & set(df.index))
    #         df = df.loc[nIDs]
    #         df.index = [nID[:-2] if nID[-2:] ==
    #                     ".N" else nID for nID in nIDs]
    #     else:
    #         exit("The sample type, tumor vs normal vs all (default),\
    #         is not correctly set!")
    df.transpose().to_csv(path_or_buf="file.tsv", sep='\t')


if __name__ == '__main__':
    main()
