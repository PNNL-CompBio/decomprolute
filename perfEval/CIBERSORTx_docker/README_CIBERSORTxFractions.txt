# Version 1.0
# 12/21/2019

--------------------------------------------------------------------------------
CIBERSORTx Fractions
--------------------------------------------------------------------------------
CIBERSORTx Fractions enumerates the proportions of distinct cell subpopulations in
bulk tissue expression profiles. Unlike its predecessor, CIBERSORTx supports 
deconvolution of bulk RNA-Seq data using signature genes derived from either
single cell transcriptomes or sorted cell populations (Newman et al., Nat Biotech 2019).

--------------------------------------------------------------------------------
INSTALLATION
--------------------------------------------------------------------------------
Install Docker Desktop (https://www.docker.com/products/docker-desktop)
Open Docker Desktop on your local computer and log in.
Then, you open a terminal window, and you type the following command:
> docker pull cibersortx/fractions

The next thing you need is a token that you will provide every time you run the
CIBERSORTx executables. You can obtain the token from the CIBERSORTx website
(https://cibersortx.stanford.edu/getoken.php).

Please note that each token is uniquely tied to your user account, and tokens are
good for a specific time interval from date of request, so you will need to
request a new token when an existing one has expired.

Once you have pulled the CIBERSORTx executable from Docker, and you have obtained
a token from the CIBERSORTx website, you now have access to the CIBERSORTx Fractions
executable and can run it following the instructions below. 

--------------------------------------------------------------------------------
INSTRUCTIONS & EXAMPLES
--------------------------------------------------------------------------------
These instructions assume that you already have completed the tutorials on the 
the CIBERSORTx website (https://cibersortx.stanford.edu/tutorial.php), and have
learned how to set up a CIBERSORTx job. A typical CIBERSORTx Fractions job may take
from a few seconds to a couple of minutes depending on the size of the input files. 

Download the file packages for the examples from Download in the Menu tab on the
CIBERSORTx website.

When running the following commands, you should be able to reproduce the results 
of the examples on the website. For further information about these examples, refer
to the tutorial on the website: https://cibersortx.stanford.edu/tutorial.php.

To run CIBERSORTx Fractions locally on your computer using docker, navigate to the
directory containing the files you wish to analyze. 

Next, you have to "bind mount" directories so that they can can be accessed within
the docker container. This is done using the following command when setting up the
CIBERSORTx job:

> docker run -v {dir_path}:/src/data -v {dir_path}:/src/outdir cibersortx/fractions [Options]

Please note that you have to provide absolute paths. To better understand how to
bind mount directories and setting up the CIBERSORTx job using docker, please follow
the following examples: 

# NSCLC PBMCs Single Cell RNA-Seq (Fig. 2a,b):
# This example builds a signature matrix from single cell RNA sequencing data from
# NSCLC PBMCs and enumerates the proportions of the different cell types in a RNA-seq dataset
# profiled from whole blood using S-mode batch correction.

docker run -v absolute/path/to/input/dir:/src/data -v absolute/path/to/output/dir:/src/outdir cibersortx/fractions --username email_address_registered_on_CIBERSORTx_website --token token_obtained_from_CIBERSORTx_website --single_cell TRUE --refsample Fig2ab-NSCLC_PBMCs_scRNAseq_refsample.txt --mixture Fig2b-WholeBlood_RNAseq.txt --fraction 0 --rmbatchSmode TRUE 

# Single Cell RNA-Seq HNSCC (Fig. 2c,d):
# This example builds a signature matrix from single cell RNA sequencing data from
# HNSCC tumors (Puram et al., Cell, 2017) and enumerates the proportions of the
# different cell types in bulk HNSCC tumors reconstituted from single cell
# RNA-Seq data.

docker run -v absolute/path/to/input/dir:/src/data -v absolute/path/to/output/dir:/src/outdir cibersortx/fractions --username email_address_registered_on_CIBERSORTx_website --token token_obtained_from_CIBERSORTx_website --single_cell TRUE --refsample scRNA-Seq_reference_HNSCC_Puram_et_al_Fig2cd.txt --mixture mixture_HNSCC_Puram_et_al_Fig2cd.txt 

# Single Cell RNA-Seq Melanoma (Fig. 3c-e) (Tutorial 1):
# This example builds a signature matrix from single cell RNA sequencing data from
# melanoma (Tirosh et al., Science, 2016) and enumerates the proportions of the
# different cell types in bulk melanoma tumors reconstituted from single cell
# RNA-Seq data.

docker run -v absolute/path/to/input/dir:/src/data -v absolute/path/to/output/dir:/src/outdir cibersortx/fractions --username email_address_registered_on_CIBERSORTx_website --token token_obtained_from_CIBERSORTx_website --single_cell TRUE --refsample scRNA-Seq_reference_melanoma_Tirosh_SuppFig_3b-d.txt --mixture mixture_melanoma_Tirosh_SuppFig_3b-d.txt 

# Abbas et al:
# This examples builds a signature matrix from sorted cell populations profiled on
# microarray, and enumerated cell proportions in bulk samples from microarray.

docker run -v absolute/path/to/input/dir:/src/data -v absolute/path/to/output/dir:/src/outdir cibersortx/fractions --username email_address_registered_on_CIBERSORTx_website --token token_obtained_from_CIBERSORTx_website --refsample reference_purified_GSE11103.txt --phenoclasses phenoclasses_GSE11103.txt --mixture mixture_GSE11103.txt  --QN TRUE


--------------------------------------------------------------------------------
Options for cibersortxfractions:
--------------------------------------------------------------------------------
For further details about the different options, refer to the tutorials on the 
website: https://cibersortx.stanford.edu/tutorial.php
For further details about the input file format, refer to the upload file page on
the website: https://cibersortx.stanford.edu/upload.php

--mixture       <file_name>  Mixture matrix [required for running CIBERSORTx, optional 
                        for creating a custom signature matrix only]
--sigmatrix     <file_name>  Signature matrix [required: use preexisting matrix or 
                        create one]
--perm          <int>   No. of permutations for p-value calculation [default: 0]
--label         <char>  Sample label [default: none]
--rmbatchBmode       <bool>  Run B-mode batch correction [default: FALSE]
--rmbatchSmode       <bool>  Run S-mode batch correction [default: FALSE]
--sourceGEPs    <file_name>  Signature matrix GEPs for batch correction [default: 
                        sigmatrix]
--QN            <bool>  Run quantile normalization [default: FALSE]
--absolute      <bool>  Run absolute mode [default: FALSE]
--abs_method    <char>  Pick absolute method [\'sig.score\' (default) or 
                        \'no.sumto1\']
--verbose       <bool>  Print verbose output to terminal [default: FALSE]
--outdir<char>  Output directory [default: "<mixture dir>/CIBERSORTx_output"]

Options for creating a custom signature matrix:
--refsample     <file_name>  Reference profiles (w/replicates) or labeled scRNA-Seq 
                        data [required]
--phenoclasses  <file_name>  Cell type classes [required, if single_cell = FALSE]
--single_cell   <bool>  Create matrix from scRNA-Seq data [default: FALSE]
--G.min         <int>   Minimum number of genes per cell type in sig. matrix 
                        [default: 50, if single_cell = TRUE: 300]
--G.max         <int>   Maximum number of genes per cell type in sig. matrix 
                        [default: 150, if single_cell = TRUE: 500]
--q.value       <int>   Q-value threshold for differential expression 
                        [default: 0.3, if single_cell = TRUE: 0.01]
--filter        <bool>  Remove non-hematopoietic genes [default: FALSE]
--k.max         <int>   Maximum condition number [default: 999]
--remake        <bool>    Remake signature gene matrix [default: False]
--replicates     <int>    Number of replicates to use for building scRNAseq 
                        reference file [default: 5]
--sampling      <float>    Fraction of available single cell GEPs selected using
                        random sampling [default: 0.5]
--fraction      <float>    Fraction of cells of same identity showing evidence of 
                        expression [default: 0.75]

--------------------------------------------------------------------------------
CIBERSORTx Fractions Mode - OUTPUT
--------------------------------------------------------------------------------
- *_Results.txt: file enumerating the fractions of the different cell types in 
mixture samples.

If batch correction is performed (B-mode or S-mode):
- *_Adjusted.txt: file enumerating the fractions of the different cell types in 
mixture samples after batch correction.
- *_Mixtures_Adjusted.txt: the input mixture file after batch correction

If S-mode batch correction is performed:
- [signature matrix filename]_Adjusted: the signature matrix after batch correction 

--------------------------------------------------------------------------------
CIBERSORTx Fractions Source Code
--------------------------------------------------------------------------------
Source code is available for academic non-profit use upon reasonable request (mailto:cibersortx@gmail.com).
