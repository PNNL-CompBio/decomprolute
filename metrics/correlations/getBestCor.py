'''
simple python script that gets best correlation from files
'''

import sys
import pandas
import os

filelist = sys.argv[2:]
#print(filelist)
maxval = 0
matrix = ""
alg = ""
for file in filelist:
    [data,disease,mrna,to,prot,mat,cor] = os.path.basename(file).split('-')
    if mrna == prot:
        tab = pandas.read_csv(file, sep='\t', header=None)
        meanVal = tab[1].mean()
        if meanVal > maxval:
            maxval = meanVal
            alg = mrna
            matrix = mat

if sys.argv[1]=='alg':
    print(alg)
else:
    print(matrix)
