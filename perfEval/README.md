# Performance evaluation

This document describes the current test matrix of comparisons we want to carry
out so that we can keep track of what analysis should be done. We generally have created
four different ways to evaluate protein deconvolultion algorithms.

## Tests of various algorithms
Below are the three different tests we perform. For each test, there are numerous
metrics we use to evaluate the performance as well as different parameters.

To add an additional algorithm, it must be included in the [`run-deconv.cwl`](./run-deconv.cwl)
script in this directory.

### Protein-mRNA similarities
One test we will perform is to evaluate the similarities in tumor deconvolution
algorithms between mRNA and proteins from the same tumors with the same signature matrices.
These tests can be evaluated across signature matrices, tissue types (tumor, normal, all) and cancer
types.

*add documentation to run in `mrna-prot` directory*


### Imputation analysis
Here we measure how sensitive an algorithm is to imputed vs. unimputed proteomics data

*add documentation to run in the `imputation` directory*

### Simulated data analysis
Here we tests how well each algorithm performs on simulated data.

*add documetnation to run in the `data-sim` directory.


## Vector and matrix comparisons
The following are options:
- Vector comparisons: these measure correlation across patients OR subtypes using spearman or pearson Correlation
- Matrix comparisons: these measure distances between matrices.


## Parameters to compare
In addition to the various algorithms, there are also
