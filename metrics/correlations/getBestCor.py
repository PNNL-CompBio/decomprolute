'''
simple python script that gets best correlation from files
'''

import sys
import pandas

filelist = sys.argv[1:]

max = 0
matrix = ""
alg = ""
for file in filelist:
    [data,disease,mrna,to,prot,mat,cor] = file.split('-')
    if mrna == prot:
        tab = pandas.read_csv(file, sep='\t', header=None)
        meanVal = tab[1].mean()
        if meanVal > max:
            max = meanVal
            alg = mrna
            matrix = mat
print(max)
print(alg)
print(matrix)
