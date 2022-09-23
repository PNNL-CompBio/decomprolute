'''
simple python script that gets best correlation from simulation summary file
'''

import sys
import pandas
import os

filelist = sys.argv[2]
#print(filelist)
maxval = 0
matrix = ""
alg = ""
tab = pandas.read_csv(filelist, sep=' ')

##now get the max average value
grouped = tab.groupby(['prot.algorithm', 'matrix']).mean('value')
maxval = grouped.max().value
istop = [v == maxval for v in grouped.value]
grouped = grouped.reset_index()
alg = grouped[istop].reset_index()['prot.algorithm'][0]
matrix = grouped[istop].reset_index()['matrix'][0]

if sys.argv[1]=='alg':
    print(alg)
else:
    print(matrix)
