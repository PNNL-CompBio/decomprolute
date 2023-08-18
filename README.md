# Decomprolute: Benchmarking study of proteomic based tumor deconvolution
The goal of this package is to provide a framework for the benchmarking of tumor deconvolution algorithms specifically on proteomics data. To run the platform, please see our [primary documentation site](https://pnnl-compbio.github.io/decomprolute). 

Here we describe how to contribute to the project. We employ a modular, containerized, framework written in the Common Workflow Language to enable plug-n-play assessment of novel algorithms as described in the image below.
<img src="docs/deconvFIgure1.png" width="400">

Status of docker builds:

| Status | Description |
| --- | --- |
| ![Protein docker builds](https://github.com/pnnl-compBio/decomprolute/actions/workflows/docker-build-1.yml/badge.svg) | Collects CPTAC protein data |
| ![mRNA docker builds](https://github.com/pnnl-compBio/decomprolute/actions/workflows/docker-build-2.yml/badge.svg)| Collects CPTAC mRNA data |
| ![Algorithm docker builds](https://github.com/pnnl-compBio/decomprolute/actions/workflows/decon-alg-docker.yml/badge.svg) | Builds deconvolution docker images |
| ![Metrics docker builds](https://github.com/pnnl-compBio/decomprolute/actions/workflows/metrics-docker-build.yml/badge.svg) | Builds metrics and figure docker images |

## How to contribute

As a benchmarking platform, we constructed an architecture that enables others to contribute and add their own customization. While our [documentation site](https://pnnl-compbio.github.io/decomprolute/) has information on how to run the platform, this page focuses on how to contribute.

### Adding a new algorithm
Once you have written an algorithm, we require first a script to run the algorithm, and then integration into our larger script.


To add a tumor deconvolution algorithm this platform requires two inputs:
1. An expression matrix
2. A cell type matrix

As such we recommend building a [Docker](https://www.docker.com/) container that runs your algorithm together with a [Common Workflow Language]() script to run the algorithm with the two inputs (labeled `expression` and `signature`. The expected output is a matrix called `deconvoluted`.

Once you have a script that can run, you can modify the `run-deconv.cwl` script in the [./tumorDeconvAlgs]() directory. This script takes the same parameters as the script described above but also an additional parameter called `alg`.

Once this is complete, you should be able to run a test command such as

``` 1c-enterprise
cwltool https://raw.githubusercontent.com/PNNL-CompBio/decomprolute/main/metrics/prot-deconv.cwl --cancer hnscc --protAlg [yourAlgNameHere] --sampleType tumor --signature LM7c

```

Once this test script can run, you can create a pull request from your fork.


### Adding a new cell type matrix
It is important to test new signature matrices as they evolve, and therefore we created a separate module to enable the creation of custom cell-type matrices.

The easiest way to add a custom signature matrix is to copy a weighted matrix into the [./signature_matrices](./signature_matrices) directory. The rows of the matrix represent gene names (the first column should be an HGNC gene name) and the columns represent cell types. Once the docker image rebuilds with this file in the directory, it can be called by the `cwl` script.

### Updating documentation

We also try to keep our [documentation site](https://pnnl-compbio.github.io/decomprolute/) up to date. If you have any updates to this, please create a pull request with updates to the [docs/index.md](docs/index.md) page.

## Software requirements

To implement your algorithm in this framework, you will need a CWL engine and Docker installed.

- [cwltool 3.0.20210124104916^](https://github.com/common-workflow-language/cwltool)
- [Docker](https://docs.docker.com/get-docker/)

