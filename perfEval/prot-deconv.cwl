#!/usr/bin/env cwltool
class: Workflow
label: prot-deconv
id: prot-deconv
cwlVersion: v1.2

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement


inputs:
   signature:
     type: File
   protAlg:
     type: string
   cancerType:
     type: string
   sampleType:
     type: string

steps:
  download-prot:
    run: ../protData/prot-data-cwl-tool.cwl
    in:
      cancerType: cancerType
      sampleType: sampleType
    out:
      [matrix]
  run-deconv:
    run: run-deconv.cwl
    in:
      signature: signature
      alg: protAlg
      cancerType: cancerType
      dataType:
        valueFrom: 'prot'
      sampleType: sampleType
      matrix: download-prot/matrix
    out:
      [deconvoluted]
  
outputs:
  deconvoluted:
    type: File
    outputSource:
      - run-deconv/deconvoluted
