#!/usr/bin/env cwltool
class: Workflow
label: prot-deconv
id: prot-deconv
cwlVersion: v1.1

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:
   signature:
     type: string
   protAlg:
     type: string
   data:
     type: File
	

steps:
  download-mat:
    run: ../signature_matrices/get-signature-matrix.cwl
    in:
      sigMatrixName: signature
    out:
      [sigMatrix]
  run-deconv:
    run: ../tumorDeconvAlgs/run-deconv.cwl
    in:
      matrix: inputs/data
      signature: download-mat/sigMatrix
      alg: protAlg
    out:
      [deconvoluted]
  
outputs:
  deconvoluted:
    type: File
    outputSource:
      - run-deconv/deconvoluted
