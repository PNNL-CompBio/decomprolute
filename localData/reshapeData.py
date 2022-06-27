import pandas as pd
import os

allfiles = [a for a in os.listdir('data') if 'tsv' in a]
for fname in allfiles:
    fname = 'data/'+fname
    print(fname)
    tab = pd.read_csv(fname,sep='\t')
    if "HGNC_Approved_Symbol" in tab.columns:
        tab = tab.iloc[:,2:].groupby('HGNC_Approved_Symbol').median()
    elif 'gene_name' in tab.columns:
        tab = tab.iloc[:,1:].groupby('gene_name').median()
    else:
        print(tab.columns)
    tab.to_csv('new'+fname,sep='\t')
