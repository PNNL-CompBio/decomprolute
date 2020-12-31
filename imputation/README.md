## Proteomic data imputation
This module leverages the imputation algorithm developed during the [NCI-CPTAC DREAM Proteogenomics Challenge](https://github.com/WangLab-MSSM/DreamAI). The resulting DreamAI algorithm imputes missing values in proteomics data given observed proteins.  

### Usage

This tool can be run from the command-line with the CWL tool file and an input YAML file:

``` shell
cwl-runner imputation-tool.cwl imputation-input.yml 
```

This will output an `imputed_file.tsv` containing a tab-separated matrix of imputed protein values in the CWL tool's working directory.

### Inputs

The `imputation.yml` file can be updated with custom inputs. 

The included example file uses test dummy data in this directory:

`imputation-input.yml`
```yaml
input_f:
  class: File
  path: test-data.csv

use_missForest: 'false'
```

This module requires two inputs:

| Parameter                 | Default       | Description   |	
| :------------------------ |:-------------:| :-------------|
| input_f	       |	           |path to comma-separated file containing protein data with missing values, where rows are genes and columns are samples
| use_missForest         |            |boolean string ('true' or 'false') indicating whether to use missForest imputation. Using missForest will take longer.