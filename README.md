# Proteomics Tumor Deconvolution Metrics
A suite of scientific workflows to assess metrics to compare efficacy of protein-based tumor deconvolution algorithms. The goal of this project is to standardize the analysis and comparison of various tumor deconvolution datasets to compare their efficacy with different parameters.

## To Run
This repository contains all the tools needed to compare tumor deconvolution algorithms. So far we are focusing on comparing proteomic to mRNA measurements and assessing their correlation via the Spearman Rank statistic. To evaluate and see the results, you can:

``` shell
cd perfEval
cwltool scatter-test.cwl scatter-test.yml
```
This will run the evaluation in our test `YAML` file. To update the parameters, create your own `YAML` file. The algorithm currently has five parameters:
1. mrna-algorithms: List of algorithms to use to deconvolve mRNA data. One of `epic`, `xcell`, `cibersort`, `mcpcounter`.
2. prot-algorithms: List of algorithms to use to deconvolve protein data. One of `epic`, `xcell`, `cibersort`, `mcpcounter`.
3. cancerTypes: List of cancer types
4. signatures: List of signature matrices, currently found in the [signature matrix](./signature_matrices) directory
5. tissueTypes: list of tissue types: `tumor`, `normal`, or `all`

### To add your algorithm
To test your own algorithm, please ensure that it will work with the signature matrices in this repository as well as the matrices generated in the mRNA and protein modules. Then deposit your `CWL` script and add your algorithm to the `call-deconv-and-cor.cwl` file.

### Example results
Currently the results produce two PDF files: one that plots the correlation across cell types for each tumor type/algorithm/tissue combination, and one that plots the correlation across patient cohorts.

## Architecture
We propose a modular architecture to enable 'plug and play' comparisons of different datasets and tools.The modules fall into three categories, each with a data collection and analysis module.
![Architecture](./arch.png)

These modules are each describe below.


### Deconvolution algorithms
List here

### Deconvolution signatures
There are numerous ways to define the individual cell types we are using to run the deconvolution algorithms. We will upload specific lists to compare in our workflow.

| List Name | Description | Source |
| --- | --- | --- |
| LM7c | Seven cell types (B, CD4 T, CD8 T, dendritic cells, granulocytes, monocytes, NK) collapsed from proteomic data | [Rieckmann et al.](https://pubmed.ncbi.nlm.nih.gov/28263321/)|
| 3' PBMCs | Seven cell types (B, CD4 T, CD8 T (CD8 T + NK T), dendritic cells, megakaryocytes, monocytes, NK) from scRNA-seq data | [Newman et al.](https://pubmed.ncbi.nlm.nih.gov/31061481/)|
| LM10 | Ten cell types predicted by MCPCounter signature | |
| ? | Should we add additional cell type markers? | |


### Proteomic data collection
We have collect pre-formatted sample data from the [CPTAC Python API](https://github.com/PayneLab/cptac) to better match the mRNA data. This CWL tool and Docker image are in the [protData](./protData) directory.

To run:

``` shell
cd protData
docker build -t sgosline/prot-dat
cwl-runner prot-data-cwl-tool.cwl
```
This will output a `file.tsv` containing a matrix of protein values.

We will also build a script/image that computes tumor-normal data from the [Proteomic Data Commons](https://proteomic.datacommons.cancer.gov/pdc/) in a self-contained docker image that selects the most differentially expressed proteins in each tumor sample. This can be found in the [protData](./protData) directory.




### mRNA data collection
All data is currently being downloaded via the [CPTAC Python API](https://github.com/PayneLab/cptac) to pull matched mRNA data for each proteomic patient sample. The code is located in the [mRNA module](./mRNAData).

To run:

``` shell
cd mRNAData
docker build -t sgosline/mrna-dat .
cwl-runner mrna-data-cwl-tool.cwl --cancerType ccrcc
```
This will output a file.tsv that includes a matrix of CCRCC data.
