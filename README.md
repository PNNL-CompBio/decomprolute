# Decomprolute: Benchmarking study of proteomic based tumor deconvolution
The goal of this package is to provide a framework for the benchmarking of tumor deconvolution algorithms specifically on proteomics data. As such, we welcome contribtions from the community to add new algorithms and datasets.

We employ a modular, containerized, framework written in the Common Workflow Language to enable plug-n-play assessment of novel algorithms as described in the image below.
<img src="docs/deconvFIgure1.png" width="400">


![Data docker builds](https://github.com/pnnl-compBio/decomprolute/actions/workflows/docker-build.yml/badge.svg)
![Algorithm docker builds](https://github.com/pnnl-compBio/decomprolute/actions/workflows/alg-docker-build.yml/badge.svg)

## How to contribute

To add an *algorithm* we recommend you create your own Docker image with CWL tool to run it. Once the CWL is accessible remotely (via github, for example), it can be added to the [primary deconvolution tool](./metrics/run-deconv.cwl) via a pull request. See the [contribution_guide](./contribution_guide) for more details.

To add a *signature matrix* we recommend creating a text file representing the marker genes and cell types and creating a pull request to add it to the [signature matrices](./signature_matrices) folder.

Algorithms in the framework are configured with the [Common Workflow Language, CWL](#https://www.commonwl.org/user_guide/) and rely on [Docker](https://www.docker.com/) runtime environments to execute source code.

There are essentially two requirements to run a novel algorithm to the framework:

- Docker image with executable source code and all pre-requisite software installed
- CWL tool file describing expected inputs, outputs, and runtime environment

### Software requirements

To implement your algorithm in this framework, you will need a CWL engine and Docker installed.

- [cwltool 3.0.20210124104916^](https://github.com/common-workflow-language/cwltool)
- [Docker](https://docs.docker.com/get-docker/)

### Contribute an algorithm

Here are the following steps needed to add your algorithm.

To add an algorithm you will need to encapsulate a script that runs the algorithm with the list of signature matrices we have on a specific dataset. Then you will need to add it to the cwl file that captures each algorithm.


#### Validating input data

To add an *algorithm* we recommend you create your own Docker image with CWL tool to run it. Once the CWL is accessible remotely (via github, for example), it can be added to the [primary deconvolution tool](./metrics/run-deconv.cwl) via a pull request. See the [contribution_guide](./contribution_guide) for more details.

### Contribute a cell type matrix
To add a cell type atrix, follow these steps.

#### Validating cell type matrix
