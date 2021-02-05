## repBulk description
Francesca's tumor deconvolution algorithm

### Usage

This tool can be run from the command-line with the CWL tool file and an input YAML file:

``` shell
cwl-runner rep-bulk.cwl rep-bulk-input.yml 
```

This will output an `output_rep_bulk.tsv` containing a tab-separated matrix of .... [Insert description here]

### Inputs

The `rep-bulk-input.yml` file can be updated with custom inputs. 

The included example file uses test dummy data in this directory:

`rep-bulk-input.yml`
```yaml
list_gene_file:
  class: File
  path: toy_list_gene.tsv
  
data_file:
  class: File
  path: toy_data.tsv
  
n_iter: '100'

burn_in: '100'
```

This module requires two inputs:

| Parameter                 | Default       | Description   |	
| :------------------------ |:-------------:| :-------------|
| list_gene_file	       |	           |path to tab-separated file with cell types as the column names and gene symbols as rows
| data_file         |            |path to tab-separated expression file, with samples as the column names and gene symbols as rows
| n_iter         |            |number of iterations ...?
| burn_in         |            |..?
