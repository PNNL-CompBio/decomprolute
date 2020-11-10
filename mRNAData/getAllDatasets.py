'''
Get all cptac data
downloads data into docker image
'''

import cptac
for ds in ['brca', 'ccrcc', 'colon', 'ovarian']:
    cptac.download(dataset=ds)
