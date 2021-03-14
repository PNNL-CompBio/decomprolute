'''
Get all cptac data
downloads data into docker image
'''

import cptac
for ds in ['hnscc', 'brca', 'ccrcc', 'endometrial', 'colon', 'ovarian', 'luad']:
    cptac.download(dataset=ds)
