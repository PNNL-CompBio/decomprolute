#!/usr/local/bin/python

import numpy as np
# from scipy.special import rel_entr
from scipy.spatial.distance import jensenshannon, euclidean
import scipy as sp
import pandas as pd
# import seaborn as sns
import argparse


def ed(a, b):
    if len(a) != len(b):
        print("The two arrays are not same size!")
    if np.sum(a) == 0 or np.sum(b) == 0:
        return(np.nan)
    a /= np.sum(a)
    b /= np.sum(b)
    dist = euclidean(a, b)
    return(dist)


def js(a, b):
    if len(a) != len(b):
        print("The two arrays are not same size!")
    if np.sum(a) == 0 or np.sum(b) == 0:
        return(np.nan)
    a /= np.sum(a)
    b /= np.sum(b)
    dist = jensenshannon(a, b)
    return(dist)


def ks(a, b):
    if len(a) != len(b):
        print("The two arrays are not same size!")
    if np.sum(a) == 0 or np.sum(b) == 0:
        return(np.nan)     
    a /= np.sum(a)
    b /= np.sum(b)
    dist = np.amax(np.abs(np.cumsum(a) - np.cumsum(b)))
    return(dist)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--matrixA', dest='matrixA',
                        help='Deconvoluted matrix A')
    parser.add_argument('--matrixB', dest='matrixB',
                        help='Deconvoluted matrix B')
    parser.add_argument('--method', dest='method', help='Use "ed" (Euclidean distance), "js" (Jensen-Shannon divergence), or "ks" (Kolmogorov-Smirnov distance)',
                        default='js')
    # parser.add_argument('--output', dest='output',
    #                     help='Output file for the correlation values')
    opts = parser.parse_args()

    A = pd.read_csv(opts.matrixA, sep='\t', index_col=0)
    B = pd.read_csv(opts.matrixB, sep='\t', index_col=0)

    aCols = list(A.columns)
    bCols = list(B.columns)
    aRows = list(A.index)
    bRows = list(B.index)
    intersectCols = list(set(aCols) & set(bCols))
    intersectRows = list(set(aRows) & set(bRows))

    A = A.loc[intersectRows, intersectCols]
    B = B.loc[intersectRows, intersectCols]
    A = A.fillna(0)
    B = B.fillna(0)

    if opts.method == 'ed':
        distList = [ed(A[sample].to_numpy().astype(np.float32), B[sample].to_numpy().astype(np.float32))
                    for sample in intersectCols]
    elif opts.method == 'ks':
        distList = [ks(A[sample].to_numpy().astype(np.float32), B[sample].to_numpy().astype(np.float32))
                    for sample in intersectCols]
    else:
        distList = [js(A[sample].to_numpy().astype(np.float32), B[sample].to_numpy().astype(np.float32))
                    for sample in intersectCols]
    dists = pd.Series(distList)
    dists.index = intersectCols
    dists.to_csv("dist.tsv", sep='\t', header=False)


if __name__ == '__main__':
    main()
