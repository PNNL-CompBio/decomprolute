## repBulk description
Francesca's tumor deconvolution algorithm

### Usage

This tool can be run from the command-line with the CWL tool file and an input YAML file:

``` shell
cwl-runner bayes-de-bulk.cwl bayes-de-bulk-input.yml 
```

This will output an `output_bayes_de_bulk.tsv` containing a tab-separated matrix of .... [Insert description here]

### Inputs

The `bayes-de-bulk-input.yml` file can be updated with custom inputs. 

The included example file uses test dummy data in this repository:

`bayes-de-bulk-input.yml`
```yaml
expressionFile:
  class: File
  path: slim.tsv
signatureMatrix:
  class: File
  path: signature_matrices/LM22.tsv
```

This module requires two inputs:

| Parameter                 | Default       | Description   |	
| :------------------------ |:-------------:| :-------------|
| expressionFile	       |	           |path to tab-separated file with cell types as the column names and gene symbols as rows
| signatureMatrix         |            |path to tab-separated signature matrix

### Outputs

This CWL will output two files into the working directory: 

| output_bayes_de_bulk.tsv	       |	           |...?
| output_bayes_de_bulk_gibbs.Rdata         |            |Rdata object with ...?
