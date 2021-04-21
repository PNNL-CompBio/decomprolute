# Performance evaluation

This document describes the current test matrix of comparisons we want to carry
out so that we can keep track of what analysis should be done. We generally have created
four different ways to evaluate protein deconvolultion algorithms.

## To run a deconvolution algorithm
The CWL workflow [run-deconv.cwl](./run-deconv.cwl) takes the following arguments
to run an algorithm included in our suite:
| Argument | Required? | Description|
| --- | --- | --- |
| signature | yes | Signature matrix file used to run the deconvolution, such as those located in [the signature matrix directory](../signature_matrices)|
| alg | yes | Name of algorithm. Currently implemented are: `cibersort`, `xcell`, `epic`, `mcpcounter`, and `bayesdebulk`|
| cancerType | no | Optional argument to describe cancer type|
| dataType | no | Optional argument to describe data type (e.g. protein or mRNA)|
| sampleType | no | Optional argument to describe sample type (e.g. tumor or normal|


## Tests of various algorithms
Below are the three different tests we perform. For each test, there are numerous
metrics we use to evaluate the performance as well as different parameters.

To add an additional algorithm, it must be included in the [`run-deconv.cwl`](./run-deconv.cwl)
script in this directory.

### Protein-mRNA similarities
One test we will perform is to evaluate the similarities in tumor deconvolution
algorithms between mRNA and proteins from the same tumors with the same signature matrices.
These tests can be evaluated across signature matrices, tissue types (tumor, normal, all) and cancer
types. These tests are located in the [`mrna-prot` directory](./mrna-prot).


### Imputation analysis
Here we measure how sensitive an algorithm is to imputed vs. unimputed proteomics data.
The documentation to evaluate this is in the [`imputation` directory](./imputation).

### Simulated data analysis
Here we tests how well each algorithm performs on simulated data.
The documentation to test this is in the [`data-sim` directory](./data-sim).


## Vector and matrix comparisons
The following are options:
- Vector comparisons: these measure correlation across patients OR subtypes using spearman or pearson Correlation
- Matrix comparisons: these measure distances between matrices.
