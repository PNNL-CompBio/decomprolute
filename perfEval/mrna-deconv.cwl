#!/usr/bin/env cwltool
class: Workflow
label: mrna-deconv
id: mrna-deconv
cwlVersion: v1.2

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  
inputs:
   signature:
      type: File
   mrnaAlg:
      type: string
   cancerType:
      type: string
   sampleType:
      type: string

steps:
  download-mrna:
    run: ../mRNAData/mrna-data-cwl-tool.cwl
    in:
      cancerType: cancerType
      sampleType: sampleType
    out:
      [matrix]
  run-deconv:
    run: run-deconv.cwl
    in:
      matrix: download-mrna/matrix
      signature: signature
      alg: mrnaAlg
    out:
      [deconvoluted]
  
outputs:
  deconvoluted:
    type: File
    outputSource:
      - run-deconv/deconvoluted
   

