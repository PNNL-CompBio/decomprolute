# Decomprolute: Benchmarking study of proteomic based tumor deconvolution
The goal of this package are to run tumor deconvolution algorithms on multi-omics data. We provide two basic use cases:
1. Evaluate the performance of new algorithms on proteogenomic data
2. Identify the *best* tool for unseen proteogenomic data

These two use cases are enabled by the modular dockerized framework shown below. We employed a modular architecture to enable 'plug and play' comparisons of different datasets and tools. This will enable you to use the tool fully remotely, without having to download the code yourself. The modules fall into three categories, each with a data collection and analysis module.

<img src="./deconvFIgure1.png" width="400">

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

To add an algorithm you will need to encasulate a script that runs the algorithm with the list of signature matrices we have on a specific datase


#### Validating input data

To add an *algorithm* we recommend you create your own Docker image with CWL tool to run it. Once the CWL is accessible remotely (via github, for example), it can be added to the [primary deconvolution tool](./metrics/run-deconv.cwl) via a pull request. See the [contribution_guide](./contribution_guide) for more details.

### Contribute a cell type matrix
To add a cell type atrix, follow these steps.

#### Validating cell type matrix
