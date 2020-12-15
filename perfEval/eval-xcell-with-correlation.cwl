#!/usr/bin/env cwltool

class: Workflow
label: test-xcell-with-correlation
id: test-xcell-with-correlation
cwlVersion: v1.0

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  cancerType:
    type: string

outputs:
  corr:
    type: File
    outputSource: calc-corr/corr

steps:
  download-mrna:
    run: ./mrna-data-cwl-tool.cwl
    in:
      cancerType: cancerType
    out:
      [matrix]

  download-prot:
    run: prot-data-cwl-tool.cwl
    in:
      cancerType: cancerType
    out:
      [matrix]

  mrna-deconv:
    run: ./run-xcell-tool.cwl
    in:
      expression:
        source: download-mrna/matrix
    out:
      [deconvoluted]

  prot-deconv:
    run: ./run-xcell-tool.cwl
    in:
      expression:
        source: download-prot/matrix
    out:
      [deconvoluted]

  calc-corr:
    run: ./deconv-corr-cwl-tool.cwl
    in:
      transcriptomics:
        source: mrna-deconv/deconvoluted
      proteomics:
        source: prot-deconv/deconvoluted
    out:
      [corr]

  
