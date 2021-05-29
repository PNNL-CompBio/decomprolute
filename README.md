# Decomprolute: Benchmarking study of proteomic based tumor deconvolution 
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
| LM22 | The original matrix from cibersort  | |


### Data collection
We have collect pre-formatted sample data from the [CPTAC Python API](https://github.com/PayneLab/cptac) to better match the mRNA data. This CWL tool and Docker image are in the [protData](./protData) and [mRNAdata](./mRNAData) directories.

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


