## Performance evaluation

This document describes the current test matrix of comparisons we want to carry out so that we can keep track of what analysis should be done.

### Permutation axes
Essentially we want to evaluate the performance of each *algorithm* and *cell type matrix* across each of the six cancer types. Our performance will be evaluated both using correlation and mutual information between protein-based and mRNA-based algorithms. We will also compare proteomic prediction to known immune subtypes.

### Tests to perform

Below is a table of various tests and the individual links to files that perform them. The goal is that a new algorithm can be folded into the test matrix without too mcuh work.

| Algorithm | Cell Matrix for mRNA | Cell Matrix for Protein |
| --- | --- | --- |
| CIBERSORTx | LM22 | LM22  |
| xCell | LM22 | LM22 |
| mcpcounter | LM22 | LM22 |
| CIBERSORTx | LM22 | Rieckmann |


