# Decomprolute: Benchmarking study of proteomic based tumor deconvolution
The goal of this package are to run tumor deconvolution algorithms on multi-omics data. We provide two basic use cases: 
1. Evaluate the performance of new algorithms on proteogenomic data
2. Identify the *best* tool for unseen proteogenomic data

These two use cases are enabled by the modular dockerized framework shown below. We employed a modular architecture to enable 'plug and play' comparisons of different datasets and tools. This will enable you to use the tool fully remotely, without having to download the code yourself. The modules fall into three categories, each with a data collection and analysis module.
![Architecture](./deconvFIgure1.png,width=100)

## How to use

To run the code you will need to download [Docker](http://docker.com) and a [CWL interpreter](https://github.com/common-workflow-language/cwltool) such as CWL tool. These tools will enable the different modules to interoperate. For example, to run single deconvolution algorithm on HNSCC data you can do the following:

``` shell
cwltool https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/main/metrics/prot-deconv.cwl --cancer hnscc --protAlg mcpcounter --sampleType tumor --signature LM7c
```
This will run the MCP-counter algorithm on proteomics data from the CPTAC breast HNSCC cohort using our LM7c signature. Here are more specific use cases. 

### To benchmark a new algorithm or cell signature on CPTAC data
If you have developed a new deconvolution algorithm and/or cell signature matrix that you want to compare to others, we recommend you add them to this framework so they can easily be compared. 

To add an *algorithm* we recommend you create your own Docker image with CWL tool to run it. Once the CWL is accessible remotely (via github, for example), it can be added to the [primary deconvolution tool](./metrics/run-deconv.cwl) via a pull request. See the [contribution_guide](./contribution_guide) for more details.

To add a *signature matrix* we recommend creating a text file representing the marker genes and cell types and creating a pull request to add it to the [signature matrices](./signature_matrices) folder. 

### To find the *best* algorithm for your data
If you have a specific dataset you'd like to deconvolve but are not sure which tool to use, you can use the tools in the metrics directory to determine and then run the *best* algorithm for your data. To assess which algorithm/signature matrix provides the best agreement between mRNA and protein datasets, you will need to provide two matrices from your own data as input into the [run-best-alg-by-cor](./metrics/mrna-prot/run-best-alg-by-cor.cwl) workflow. To assess which algorithm/signature matrix best agrees with simulated data, you can use *either* mRNA or protein data as input into the [run-best-alg-by-sim](./metrics/data-sim/run-best-alg-by-sim.cwl) workflow. 

## To review the results of our manuscript
In the manuscript we completed three separate tests of proteomic tumor deconvolution algorithms.

#### Performance on simulated data
We have simulated both mRNA and proteomics data from established experiments as described below. We try to evaluate mRNA data on mRNA-derived simulations, and proteomics data on proteomics-derived simulated data. The datasets themselves are stored in the [simulatedData](./simulatedData_) directory.

We have included two `YAML` files to use as test runs of each simulation.

``` shell
cd workflows/data-sim/
cwltool simul-data-comparison.cwl rna-sim-test.yml ##evaluate rna-based deconvolution
cwltool simul-data-comparison.cwl prot-sim-test.yml ##evaluate protein based deconvolution

```

These will produced the necessary summary statistics and figures.

#### mRNA-Proteomics Comparison

We also wanted to measure how _consistent_ an algorithm was between mRNA and proteomics data. This iterates through all algorithms, data, and matrices to and compares how similar each cell type prediction is across mRNA vs. proteomic samples.

``` shell
cd workflows/mrna-prot
cwltool mrna-prot-comparison.cwl alg-test.yml
```

This will run the evaluation in our test `YAML` file. To update the parameters, create your own `YAML` file. The algorithm currently has five parameters:
1. mrna-algorithms: List of algorithms to use to deconvolve mRNA data. One of `epic`, `xcell`, `cibersort`, `mcpcounter`.
2. prot-algorithms: List of algorithms to use to deconvolve protein data. One of `epic`, `xcell`, `cibersort`, `mcpcounter`.
3. cancerTypes: List of cancer types
4. signatures: List of signature matrices, currently found in the [signature matrix](./signature_matrices) directory
5. tissueTypes: list of tissue types: `tumor`, `normal`, or `all`

#### Pan-Immune clustering annotation
Lastly we can cross-reference known immune types with predicted cell types from the various deconvolution algorithms to ascertain how well


## Data
For this module we have collected real and simulated data.

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
We also evaluate the algorithms on simulated data.


## Algorithms
We have included numerous algorithms in this package. Docker files and requisite data are included in the [tumorDeconvAlgs](./tumorDeconvAlgs) folder.

| Algorithm                           | Source |
| ---                                 | ---    |
| [cibersort](./tumorDeconvAlgs/cibersort)|       |
| [epic](./tumorDeconvAlgs/epic)|  |
| [xcell](/tumorDeconvAlgs/xcell)| |
| [mcpcounter](./tumorDeconvAlgos/xcell)| |


## Cell type signatures
There are numerous ways to define the individual cell types we are using to run the deconvolution algorithms. We will upload specific lists to compare in our workflow.

| List Name | Description | Source |
| --- | --- | --- |
| LM7c | Seven cell types (B, CD4 T, CD8 T, dendritic cells, granulocytes, monocytes, NK) collapsed from proteomic data | [Rieckmann et al.](https://pubmed.ncbi.nlm.nih.gov/28263321/)|
| 3' PBMCs | Seven cell types (B, CD4 T, CD8 T (CD8 T + NK T), dendritic cells, megakaryocytes, monocytes, NK) from scRNA-seq data | [Newman et al.](https://pubmed.ncbi.nlm.nih.gov/31061481/)|
| LM10 | Ten cell types predicted by MCPCounter signature | |
| LM22 | The original matrix from cibersort  | |
