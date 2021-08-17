# Decomprolute: Benchmarking study of proteomic based tumor deconvolution
The goal of this package is to provide various metrics to assess the ability of a deconvolution algorithm to identify specific cell types in bulk proteomics data. The package is fully dockerized and can be run with the installation of Docker and a CWL-compliant tool on your local machine.

We employed a modular architecture to enable 'plug and play' comparisons of different datasets and tools.The modules fall into three categories, each with a data collection and analysis module.
![Architecture](./arch.png)

## How to use

There are multiple ways to use this package. Given the multiple modules, you can use this package to simply run a deconvolution algorithm a specific dataset, or you can swap out the algorithm for a new one or run on your own data. These various approaches are listed in the [workflows](./workflows/) directory.

### To deconvolve cell types on CPTAC data

To run a single algorithm.

### To assess performance of existing algorithms
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

### To add your own algorithm

To test your own algorithm, please ensure that it will work with the signature matrices in this repository as well as the matrices generated in the mRNA and protein modules. Then deposit your `CWL` script and add your algorithm to the `call-deconv-and-cor.cwl` file.

### To add your own data

## Data

### CPTAC Data

This algorithm leverages data collected through the clinical proteomic tumor analysis consortium (CPTAC) as the foundation of its benchmarking metrics. This consortium has collected hundreds of patient tumor data, including proteomic and transcriptomic data from the same patients. Given the general confidence in transcriptomic-based tumor convolution, we can use these data to compare transcriptomic and proteomic tumor deconvolution in the same patient samples

We have collect this data via the [CPTAC Python API](https://github.com/PayneLab/cptac) to better match the mRNA data. This CWL tool and Docker image are in the [protData](./protData) and [mRNAdata](./mRNAData) directories.

Below are the available tumor types:

Dataset name | Description | Data reuse status | Publication link
-- | -- | -- | --
Brca | breast cancer | no restrictions | https://pubmed.ncbi.nlm.nih.gov/33212010/
Ccrcc | clear cell renal cell carcinoma (kidney) | no restrictions | https://pubmed.ncbi.nlm.nih.gov/31675502/
Colon | colorectal cancer | no restrictions | https://pubmed.ncbi.nlm.nih.gov/31031003/
Endometrial | endometrial carcinoma (uterine) | no restrictions | https://pubmed.ncbi.nlm.nih.gov/32059776/
Gbm | glioblastoma | no restrictions | https://pubmed.ncbi.nlm.nih.gov/33577785/
Hnscc | head and neck squamous cell carcinoma | no restrictions | https://pubmed.ncbi.nlm.nih.gov/33417831/
**Lscc | lung squamous cell carcinoma | password access only | unpublished**
Luad | lung adenocarcinoma | no restrictions | https://pubmed.ncbi.nlm.nih.gov/32649874/
Ovarian | high grade serous ovarian cancer | no restrictions | https://pubmed.ncbi.nlm.nih.gov/27372738/
**Pdac | pancreatic ductal adenocarcinoma | password access only | unpublished**

As such, datasets have been updated to following (added hnscc):
['brca', 'ccrcc', 'endometrial', 'colon', 'ovarian', 'hnscc', 'luad']


### Simulated data
We also evaluate the algorithms on simulated data


## Algorithms
We have included numerous algorithms in this package.

### Example results
Currently the results produce two PDF files: one that plots the correlation across cell types for each tumor type/algorithm/tissue combination, and one that plots the correlation across patient cohorts.



### Deconvolution signatures
There are numerous ways to define the individual cell types we are using to run the deconvolution algorithms. We will upload specific lists to compare in our workflow.

| List Name | Description | Source |
| --- | --- | --- |
| LM7c | Seven cell types (B, CD4 T, CD8 T, dendritic cells, granulocytes, monocytes, NK) collapsed from proteomic data | [Rieckmann et al.](https://pubmed.ncbi.nlm.nih.gov/28263321/)|
| 3' PBMCs | Seven cell types (B, CD4 T, CD8 T (CD8 T + NK T), dendritic cells, megakaryocytes, monocytes, NK) from scRNA-seq data | [Newman et al.](https://pubmed.ncbi.nlm.nih.gov/31061481/)|
| LM10 | Ten cell types predicted by MCPCounter signature | |
| LM22 | The original matrix from cibersort  | |
