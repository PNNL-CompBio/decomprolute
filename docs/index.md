---
layout: post
title: Decomprolute: Benchmarking study of proteomic based tumor deconvolution
{:toc}
---
# Decomprolute

The goal of this package is to run and evaluate tumor deconvolution algorithms on multi-omics data. We provide the ability to assess a suite of algorithms and cell signature matrices such that you can select your algorithm wisely. We also provide a modular framework that enables you to add your own algorithm, cell signature, or proteogenomic dataset. For doing this, please see our [GitHub site](http://github.com/pnnl-compbio/decomprolute).

These two use cases are enabled by the modular dockerized framework shown below. We employed a modular architecture to enable 'plug and play' comparisons of different datasets and tools. This will enable you to use the tool fully remotely, without having to download the code yourself. The modules fall into three categories, each with a data collection and analysis module.
<img src="./deconvFIgure1.png" width="400">

## Contents
- [Prepare your system](#prepare-your-system)
- [Deconvolve CPTAC data](#deconvolve-CPTAC-data)
   - [CPTAC Data](#cptac-data)
   - [Algorithms](#algorithms)
   - [Cell type signatures](#cell-type-signatures)
- [To find the best algorithm for your data](#to-find-the-best-algorithm-for-your-data)
- [To review the results of our manuscript](#to-review-the-results-of-our-manuscript)
   - [Performance on simulated data](#performance-on-simulated-data)
   - [mRNA-Proteomics Comparison](#mrna-proteomics-comparison)
   - [Pan-Immune clustering annotation](#pan-immune-clustering-annotation)
- [Contribute](http://github.com/pnnl-compbio/decomprolute)

## Prepare your system

To run the code you will need to download [Docker](http://docker.com) and a [CWL interpreter](https://pypi.org/project/cwltool/) such as CWL tool that supports CWL v1.2. These tools will enable the different modules to interoperate. Once you have these two tools installed you can test it by running deconvolution on a single data type as shown below:

``` shell
cwltool https://raw.githubusercontent.com/PNNL-CompBio/decomprolute/main/metrics/prot-deconv.cwl --cancer hnscc --protAlg mcpcounter --sampleType tumor --signature LM7c
```
This will run the MCP-counter algorithm on proteomics data from the CPTAC breast HNSCC cohort using our LM7c signature. Here are more specific use cases.

## Deconvolve CPTAC data
If you have developed a new deconvolution algorithm and/or cell signature matrix that you want to compare to others, we recommend you add them to this framework so they can easily be compared. This is described better in our main [code repository](http://github.com/pnnl-compbio/decomprolute).

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


### Algorithms
We have included numerous algorithms in this package. Docker files and requisite data are included in the [existing code base](http://github.com/pnnl-compbio/decomprolute).
| Algorithm                           | Source |
| ---                                 | ---    |
| [cibersort](./tumorDeconvAlgs/cibersort)|       |
| [epic](./tumorDeconvAlgs/epic)|  |
| [xcell](/tumorDeconvAlgs/xcell)| |
| [mcpcounter](./tumorDeconvAlgos/xcell)| |


### Cell type signatures
There are numerous ways to define the individual cell types we are using to run the deconvolution algorithms. We will upload specific lists to compare in our workflow.

| List Name | Description | Source |
| --- | --- | --- |
| LM7c | Seven cell types (B, CD4 T, CD8 T, dendritic cells, granulocytes, monocytes, NK) collapsed from proteomic data | [Rieckmann et al.](https://pubmed.ncbi.nlm.nih.gov/28263321/)|
| 3' PBMCs | Seven cell types (B, CD4 T, CD8 T (CD8 T + NK T), dendritic cells, megakaryocytes, monocytes, NK) from scRNA-seq data | [Newman et al.](https://pubmed.ncbi.nlm.nih.gov/31061481/)|
| LM9 | Ten cell types predicted by MCPCounter signature | |
| LM22 | The original matrix from cibersort  | |

## To find the *best* algorithm for your data
If you have a specific dataset you'd like to deconvolve but are not sure which tool to use, you can use the tools in the metrics directory to determine and then run the *best* algorithm for your data. To assess which algorithm/signature matrix provides the best agreement between mRNA and protein datasets, you will need to provide two matrices from your own data as input into the [run-best-alg-by-cor](./metrics/mrna-prot/run-best-alg-by-cor.cwl) workflow. To assess which algorithm/signature matrix best agrees with simulated data, you can use *either* mRNA or protein data as input into the [run-best-alg-by-sim](./metrics/data-sim/run-best-alg-by-sim.cwl) workflow.

We have included test data for you to evaluate these two workflows:

``` shell
cwltool
```

## To review the results of our manuscript
In the manuscript we completed three separate tests of proteomic tumor deconvolution algorithms.

### Performance on simulated data
We have simulated both mRNA and proteomics data from established experiments as described below. We try to evaluate mRNA data on mRNA-derived simulations, and proteomics data on proteomics-derived simulated data. The datasets themselves are stored in the [simulatedData](./simulatedData_) directory.

We have included two `YAML` files to use as test runs of each simulation.

``` shell
cwltool https://raw.githubusercontent.com/PNNL-CompBio/decomprolute/main/metrics/data-sim/simul-data-comparison.cwl https://raw.githubusercontent.com/PNNL-CompBio/decomprolute/main/metrics/data-sim/rna-sim-test.yml ##evaluate rna-based deconvolution
cwltool https://raw.githubusercontent.com/PNNL-CompBio/decomprolute/main/metrics/data-sim/simul-data-comparison.cwl https://raw.githubusercontent.com/PNNL-CompBio/decomprolute/main/metrics/data-sim/prot-sim-test.yml ##evaluate protein based deconvolution

```

These will produced the necessary summary statistics and figures.

### mRNA-Proteomics Comparison

We also wanted to measure how _consistent_ an algorithm was between mRNA and proteomics data. This iterates through all algorithms, data, and matrices to and compares how similar each cell type prediction is across mRNA vs. proteomic samples.

``` shell
cwltool https://raw.githubusercontent.com/PNNL-CompBio/decomprolute/main/metrics/mrna-prot/mrna-prot-comparison.cwl https://raw.githubusercontent.com/PNNL-CompBio/decomprolute/main/metrics/mrna-prot/alg-test.yml
```

This will run the evaluation in our test `YAML` file. To update the parameters, create your own `YAML` file. The algorithm currently has five parameters:
1. `mrna-algorithms`: List of algorithms to use to deconvolve mRNA data. One of `epic`, `xcell`, `cibersort`, `mcpcounter`.
2. `prot-algorithms`: List of algorithms to use to deconvolve protein data. One of `epic`, `xcell`, `cibersort`, `mcpcounter`.
3. `cancerTypes`: List of cancer types
4. `signatures`: List of signature matrices, currently found in the [signature matrix](./signature_matrices) directory
5. `tissueTypes`: list of tissue types: `tumor`, `normal`, or `all`

### Pan-Immune clustering annotation
Lastly we can cross-reference known immune types with predicted cell types from the various deconvolution algorithms to ascertain how well predicted cell types align with immune populations.

``` shell

cwltool https://raw.githubusercontent.com/PNNL-CompBio/decomprolute/main/metrics/imm-subtypes/pan-can-immune-preds.cwl https://raw.githubusercontent.com/PNNL-CompBio/decomprolute/main/metrics/imm-subtypes/imm-args.yml

```
