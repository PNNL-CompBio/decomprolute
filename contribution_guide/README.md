## Introduction

These contribution docs will guide you through adding a novel tumor deconvolution algorithm to the evaluation platform.
This enables developers to benchmark the performance of their algorithm.


### Algorithm checklist

Algorithms in the framework are configured with the [Common Workflow Language, CWL](#https://www.commonwl.org/user_guide/) and rely on [Docker](https://www.docker.com/) runtime environments to execute source code. 

There are essentially two requirements to run a novel algorithm to the framework:

- Docker image with executable source code and all pre-requisite software installed
- CWL tool file describing expected inputs, outputs, and runtime environment

### Software requirements

To implement your algorithm in this framework, you will need a CWL engine and Docker installed. 

- [cwltool 3.0.20210124104916^](https://github.com/common-workflow-language/cwltool)
- [Docker](https://docs.docker.com/get-docker/)

### Validating input data
