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
   cancerType:
     type: string
   sampleType:
     type: string

steps:
  download-mat:
    run: ../signature_matrices/get-signature-matrix.cwl
    in:
      sigMatrixName: signature
    out:
      [sigMatrix]
  download-prot:
    run: ../protData/prot-data-cwl-tool.cwl
    in:
      cancerType: cancerType
      sampleType: sampleType
    out:
      [matrix]
  run-deconv:
    run: ../tumorDeconvAlgs/run-deconv.cwl
    in:
      matrix: download-prot/matrix
      signature: download-mat/sigMatrix
      alg: protAlg
    out:
      [deconvoluted]
  
outputs:
  deconvoluted:
    type: File
    outputSource:
      - run-deconv/deconvoluted
