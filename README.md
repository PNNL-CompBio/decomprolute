# Proteomics Tumor Deconvolution Metrics
A suite of scientific workflows to assess metrics to compare efficacy of protein-based tumor deconvolution algorithms. The goal of this project is to standardize the analysis and comparison of various tumor deconvolution datasets to compare their efficacy with different parameters.

We propose a modular architecture to enable 'plug and play' comparisons of different datasets and tools.The modules fall into three categories, each with a data collection and analysis module.
![Architecture]('./arch.png')
## Proteomic data collection
We have written a short script that pulls proteomic data from the PDC and formats it so it can be analyzed on basic tumor deconvolution platforms.
### Data source

### Deconvolution code

## Bulk RNA-Seq comparisons
For this work we need to run tumor deconvolution on bulk RNA-seq from the same PDC patients. 
### Data collection
### RNA deconvolution code

## scRNA-Seq comparisons
For this we will need to run cell identifications on scRNA seq
### Data collection
We will need to create a module that collects the code and formats it appropriately.

### Tumor assignment code
Here we describe tools that run various modules
