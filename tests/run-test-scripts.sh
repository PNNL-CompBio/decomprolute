### in the documentation we provide a lot of demos, here I just want to tests them

#!/bin/bash

## tests in readme
cwltool ../metrics/prot-deconv.cwl --cancer hnscc --protAlg mcpcounter --sampleType tumor --signature LM7c

##tests in docs
cwltool ../metrics/mrna-prot/run-best-alg-by-cor.cwl ../metrics/mrna-prot/best-test.yml


### data sim
cwltool ../metrics/data-sim/simul-data-comparison.cwl ../metrics/data-sim/rna-sim-test.yml ##evaluate rna-based deconvolution

cwltool ../metrics/data-sim/simul-data-comparison.cwl ../metrics/data-sim/prot-sim-test.yml ##evaluate protein based deconvolution


### immune tests
cwltool ../metrics/imm-subtypes/pan-can-immune-preds.cwl ../metrics/imm-subtypes/imm-args.yml

##tests in paper - need to add to doc somewhere
### mrna vs prot, all cancer
cwltool ../metrics/mrna-prot/mrna-prot-comparison.cwl ../metrics/mrna-prot/pan-can-matrix.yml
