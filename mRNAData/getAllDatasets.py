'''
Get all cptac data
downloads data into docker image
'''

import cptac
for ds in ['brca', 'ccrcc', 'ucec', 'coad','pdac', 'ovarian', 'luad', 'hnscc', 'gbm','lscc']:
    cptac.download_cancer(ds)
