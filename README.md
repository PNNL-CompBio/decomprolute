# Proteomics Tumor Deconvolution Metrics
A suite of scientific workflows to assess metrics to compare efficacy of protein-based tumor deconvolution algorithms. The goal of this project is to standardize the analysis and comparison of various tumor deconvolution datasets to compare their efficacy with different parameters.

We propose a modular architecture to enable 'plug and play' comparisons of different datasets and tools.The modules fall into three categories, each with a data collection and analysis module.
![Architecture](./arch.png)

These modules are each describe below.

## Proteomic data collection
We have written a short script that pulls proteomic data from the PDC and formats it so it can be analyzed on basic tumor deconvolution platforms.

### Data source
We collect pre-formatted tumor-normal data from the [Proteomic Data Commons]() in a self-contained docker image that selects the most differentially expressed proteins in each tumor sample. This can be found in the [./protData] directory.

However, currently we are testing with data from the WUSTL Box.

TODO: Format PDC data to look like data from the Box folder.

### Deconvolution code

We are currently evaluating three different tumor de-convolution algorithms for this project. These docker images can be found in [./tumorDeconvAlgs].

### Deconvolution signatures
There are numerous ways to define the individual cell types we are using to run the deconvolution algorithms.

| List Name | Description | Source |
| --- | --- | --- |
| LM9 | Nine cell types collapsed from proteomic data | Rieckmannn et al.|
| LM28 | 28 Protein derived cell types from original manuscript | Rieckmann et al. |
| LM22 | Cibertort X derived cell types from original manuscript | |
| LM10 | Ten cell types predicted by MCPCounter signature | |
| ? | Should we add additional cell type markers? | |



## Bulk RNA-Seq comparisons
For this work we need to run tumor deconvolution on bulk RNA-seq from the same PDC patients. These tools will operate similarly to the proteomics data.

### Data collection
Again we hope to pull data from the TCGA or perhaps the [CPTAC Python API]() to pull matched mRNA data for each proteomic patient sample

### RNA deconvolution code
We will also run similar algorithms from the [./tumorDeconvAlgs] directory to identify specific cell types. I believe most of these have their own gene lists and therefore we will not sample from various gene lists.

## scRNA-Seq comparisons
For this we will need to run cell identifications on scRNA seq
_TBD_

### Data collection
We will need to create a module that collects the code and formats it appropriately.

### Tumor assignment code
How to assign tumor types based on scRNA-seq profiles.

### Deconvolution comparison
The main crux of the approach is to evaluate _how_ we compare the different algorithms. This includes the mapping of patients between GDC and PDC and also the many statistical implications of missing data. Currently we are comparing various statistics to compare overall clustering.

1. Spearman rank correlation. This is currently handled in [./correlation]
2. Mutual information.


## Project Timeline

Because there are many pieces of this project I thought it would be wise to check in on the various aspects of the timeline.

| Milestone | Description | Lead | Deadline |
|--- | --- | --- | --- |
