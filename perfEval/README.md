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
|matrix | yes | Matrix of gene expression values to be deconvoluted. Row names are genes, column names are sample names. |

## Implemented algorithm metrics
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
Here we test how well each algorithm performs on simulated data.
The documentation to test this is in the [`data-sim` directory](./data-sim).

### Immune subtype analysis
We also evaluate how well the various cell types agree with what is expected based on the mRNA-defined immune subtypes.

## How to determine agreement
How we compare the deconvolution algorithms to the 'gold standard' of any particular approach is just as important as what data we are using. As such, we have carefully thought through the various approaches. Here are the current comparisons we employ.

### Per sample correlations
For each sample from the original matrix, we evaluate how well the cell type predictions agree between the deconvoluted protein matrix and the 'test' scenario. This test can be run using the [`deconv-corr-cwl-tool.cwl`](./correlations/deconv-corr-cwl-tool.cwl) script.

### Cell type correlations
For each cell type in the original matrix, we evaluate how well the predictions for that cell type agree across samples between the deconvoluted matrix and the 'test' scenario. This test can be run using the [`deconv-corrXcelltypes-cwl-tool.cwl`](./correlations/deconv-corrXcelltypes-cwl-tool.cwl] script.

### Matrix distance metrics
To compare two matrices, we employ a number of pairwise distance metrics to determine if the two matrices are similar or not. (song to add more details here)
