## mRNA Module
This module enables the collection of mRNA patient data using the `cptac` Python package to collect mRNA data for one of six available cancer types. This module includes the following:

| File name| Description|
| --- | ---|
|`getAllDatasets.py`| This script is run within the Docker build process to get all datasets into the `Python` environment. Obsolete after latest (aug 2023) change to package|
| `mRNADataSetsCLI.py`| This script is the primary tool to pull a specific cancer data type |
| `Dockerfile` | This file contains the two scripts above and the `cptac` Python package|
|`mrna-data-cwl-tool.cwl`| This is a CWL tool to run the Docker image with the command line tool|


## To run
There are three ways to get mRNA data, depending on your environment. Each one should output a `file.tsv` in your local directory

### If you have Python and cptac installed
Simply run the command
``` python
python mRNADataSetsCLI.py --cancerType=brca

```

### If you have Docker installed
Then you can run the command via the docker interactive mode

``` bash
docker build . -t mrna-module
docker run --volume $PWD:/tmp -ti mrna-module mRNADataSetsCLI.py --cancerType=brca
```

### If you have Docker and a CWL engine
Here we have an example using the `cwl-tool` engine, but this should run any other engine as well.

``` bash
cwl-tool mrna-data-cwl-tool.cwl --cancerType brca
```
## Cancer types

Dataset name | Description | Data reuse status | Publication link
-- | -- | -- | --
Brca | breast cancer | no restrictions | https://pubmed.ncbi.nlm.nih.gov/33212010/
Ccrcc | clear cell renal cell carcinoma (kidney) | no restrictions | https://pubmed.ncbi.nlm.nih.gov/31675502/
Colon | colorectal cancer | no restrictions | https://pubmed.ncbi.nlm.nih.gov/31031003/
Endometrial | endometrial carcinoma (uterine) | no restrictions | https://pubmed.ncbi.nlm.nih.gov/32059776/
**Gbm | glioblastoma | password access only | unpublished**
Hnscc | head and neck squamous cell carcinoma | no restrictions | https://pubmed.ncbi.nlm.nih.gov/33417831/
**Lscc | lung squamous cell carcinoma | password access only | unpublished**
Luad | lung adenocarcinoma | no restrictions | https://pubmed.ncbi.nlm.nih.gov/32649874/
Ovarian | high grade serous ovarian cancer | no restrictions | https://pubmed.ncbi.nlm.nih.gov/27372738/
**Pdac | pancreatic ductal adenocarcinoma | password access only | unpublished**

As such, datasets have been updated to following (added hnscc):
['brca', 'ccrcc', 'endometrial', 'colon', 'ovarian', 'hnscc', 'luad']
