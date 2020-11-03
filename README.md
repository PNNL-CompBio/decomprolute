# Proteomics Tumor Deconvolution Metrics
A suite of scientific workflows to assess metrics to compare efficacy of protein-based tumor deconvolution algorithms. The goal of this project is to standardize the analysis and comparison of various tumor deconvolution datasets to compare their efficacy with different parameters.

We propose a modular architecture to enable 'plug and play' comparisons of different datasets and tools.The modules fall into three categories, each with a data collection and analysis module.
![Architecture](./arch.png)

These modules are each describe below.

## Proteomic data collection
We have written a short script that pulls proteomic data from the PDC and formats it so it can be analyzed on basic tumor deconvolution platforms.

### Data source
We collect pre-formatted tumor-normal data from the [Proteomic Data Commons](https://proteomic.datacommons.cancer.gov/pdc/) in a self-contained docker image that selects the most differentially expressed proteins in each tumor sample. This can be found in the [protData](./protData) directory.  We plan to move to the [CPTAC Python API](https://github.com/PayneLab/cptac) to better match the mRNA data.

However, currently we are testing with data from the WUSTL Box.

*TODO*: Format PDC data to look like data from the Box folder.

### Deconvolution code

We are currently evaluating three different tumor de-convolution algorithms for this project. These docker images can be found in the [tumorDeconvAlgs](./tumorDeconvAlgs) directory.

### Deconvolution signatures
There are numerous ways to define the individual cell types we are using to run the deconvolution algorithms. We will upload specific lists to compare in our workflow.

| List Name | Description                                             | Source                                                        |         |                                               |                                |
| ---       | ---                                                     | ---                                                           |         |                                               |                                |
| LM28      | 28 Protein derived cell types from original manuscript  | [Rieckmann et al.](https://pubmed.ncbi.nlm.nih.gov/28263321/) |         |                                               |                                |
| LM22      | Cibertort X derived cell types from original manuscript |                                                               |         |                                               |                                |
| LM10      | Ten cell types predicted by MCPCounter signature        |                                                               |         |                                               |                                |
| LM7c      | Updated signature with data as provided                 | [Rieckmann et al.](https://pubmed.ncbi.nlm.nih.gov/28263321/)
| scPBMC3 | Single cell derived signature from CIBERSORTx | Pietro provide source/details. |


## Bulk RNA-Seq comparisons
For this work we need to run tumor deconvolution on bulk RNA-seq from the same PDC patients. These tools will operate similarly to the proteomics data.

### Data collection
Again we hope to pull data from the TCGA or perhaps the [CPTAC Python API](https://github.com/PayneLab/cptac) to pull matched mRNA data for each proteomic patient sample. There is also a harmonized dataset available on the [WUSTL Box](https://app.box.com/folder/125493976737?s=t7mcqokq7snc0awyh8qrsy6vj3jbguxw) site for those who have access.

### RNA deconvolution code
We will also run similar algorithms from the [tumorDeconvAlgs](./tumorDeconvAlgs) directory to identify specific cell types. I believe most of these have their own gene lists and therefore we will not sample from various gene lists.

## scRNA-Seq comparisons
For this we will need to run cell identifications on scRNA seq
_TBD_

### Data collection
We will need to create a module that collects the code and formats it appropriately.

### Tumor assignment code
How to assign tumor types based on scRNA-seq profiles.

### Deconvolution comparison
The main crux of the approach is to evaluate _how_ we compare the different algorithms. This includes the mapping of patients between GDC and PDC and also the many statistical implications of missing data. Currently we are comparing various statistics to compare overall clustering. Various performance evaluations will go in the [perfEval](./perfEval) directory

1. Spearman rank correlation. This is currently handled in the [correlation](./perfEval/correlations) directory.
2. Mutual information. *TODO*: create a script that computes mutual information.


## Project Timeline

Because there are many pieces of this project I thought it would be wise to check in on the various aspects of the timeline.

| Milestone | Description | Lead | Deadline | Relevant Issue|
|--- | --- | --- | --- | ---|
|Create docker images for 3 convolution tools | We are currently collected/building docker images for xCell, CIBERSORTx and MCPcounter | Song | | |
|Create CWL front-ends for each docker image ||Song || |
|Create docker + CWL for correlation test|| Song|||
|Create docker + CWL for MI test |||||
