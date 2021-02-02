## Proteomics Module
This module enables the collection of proteomics patient data using the `cptac` Python package to collect mRNA data for one of six available cancer types. This module includes the following:

| File name| Description|
| --- | ---|
|`getAllDatasets.py`| This script is run within the Docker build process to get all datasets into the `Python` environment|
| `protDataSetsCLI.py`| This script is the primary tool to pull a specific cancer data type |
| `Dockerfile` | This file contains the two scripts above and the `cptac` Python package|
|`prot-data-cwl-tool.cwl`| This is a CWL tool to run the Docker image with the command line tool|


## To run
There are three ways to get proteomics data, depending on your environment. Each one should output a `file.tsv` in your local directory

### If you have Python and cptac installed
Simply run the command
``` python
python getAllDatasets.py
python protDataSetsCLI.py --cancerType=brca

```

### If you have Docker installed
Then you can run the command via the docker interactive mode

``` bash
docker build . -t prot-module
docker run --volume $PWD:/tmp -ti prot-module python /bin/protDataSetsCLI.py --cancerType=brca
```

### If you have Docker and a CWL engine
Here we have an example using the `cwl-tool` engine, but this should run any other engine as well.

``` bash
cwl-tool prot-data-cwl-tool.cwl --cancerType brca
```

If using alongside another CWL implementation (like toil-cwl-runner or arvados-cwl-runner), 
you can install then run with `cwltool`:
```bash
pip install cwltool
cwltool prot-data-cwl-tool.cwl --cancerType brca
```
