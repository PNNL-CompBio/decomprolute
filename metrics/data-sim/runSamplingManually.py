'''
run sampling manually to avoid having to loop in CWL, whcih turned out to be cumberson

'''

import os


for i in [0,1,2,3,4,5]:
    estring = 'cwltool simul-data-sampling.cwl --signatures LM9, LM7c --simType prot --repNumber '+str(i)
    print(estring)
    os.system(estring)


##then concatenate results 
    
    
