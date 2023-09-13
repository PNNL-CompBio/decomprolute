'''
run sampling manually to avoid having to loop in CWL, whcih turned out to be cumberson

'''

import os

filelist = []
for i in [1,2,3,4]:
#    estring = 'cwltool simul-data-sampling.cwl --prot-sigs LM9 --simType prot --repNumber '+str(i)
#    print(estring)
#    os.system(estring)
#    fname='combined-cellType-correlation-'+str(i)+'.tsv'
#    os.rename(fname,'prot-LM9-'+fname)
#    filelist.append('prot-LM9-'+fname)

#    estring = 'cwltool simul-data-sampling.cwl --prot-sigs LM7c --simType prot --repNumber '+str(i)
#    print(estring)
#    os.system(estring)
#    fname='combined-cellType-correlation-'+str(i)+'.tsv'
#    os.rename(fname,'prot-LM7c-'+fname)
#    filelist.append('prot-LM7c-'+fname)
    
    estring = 'cwltool simul-data-sampling.cwl --rna-sigs LM22 --simType mrna --repNumber '+str(i)
    print(estring)
    os.system(estring)
    fname='combined-cellType-correlation-'+str(i)+'.tsv'
    os.rename(fname,'mrna-LM22-'+fname)
    filelist.append('mrna-LM22-'+fname)

#    estring = 'cwltool simul-data-sampling.cwl --rna-sigs PBMC --simType mrna --repNumber '+str(i)
#    print(estring)
#    os.system(estring)
#    fname='combined-cellType-correlation-'+str(i)+'.tsv'
#    os.rename(fname,'mrna-pbmc-'+fname)
#    filelist.append('mrna-pbmc-'+fname)




    
    
