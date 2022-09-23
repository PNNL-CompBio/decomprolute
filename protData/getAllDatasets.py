'''
Get all cptac data
downloads data into docker image
'''

import cptac
for ds in ['brca', 'ccrcc', 'colon', 'endometrial', 'gbm', 'hnscc', 'lscc', 'luad', 'ovarian']:
    cptac.download(dataset=ds)
