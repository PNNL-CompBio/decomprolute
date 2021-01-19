#!/usr/bin/env cwltool

class: Workflow
label: eval-epic-with-correlation
id: eval-epic-with-correlation
cwlVersion: v1.0

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:
  cancerType:
    type: string
  signature:
    type: File
  # missForest:
  #   type: string

outputs:
  corr:
    type: File
    outputSource: calc-corr/corr

steps:
  download-mrna:
    run: mrna-data-cwl-tool.cwl
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

  # impute-prot:
  #   run: imputation-tool.cwl
  #   in:
  #     input_f:
  #       source: download-prot/matrix
  #     use_missForest: missForest
  #   out:
  #     [matrix]

  mrna-deconv:
    run: run-epic-tool.cwl
    in:
      expression:
        source: download-mrna/matrix
      signature: signature
    out:
      [deconvoluted]

  prot-deconv:
    run: run-epic-tool.cwl
    in:
      expression:
        source: download-prot/matrix
      signature: signature
    out:
      [deconvoluted]

  calc-corr:
    run: deconv-corr-cwl-tool.cwl
    in:
      transcriptomics:
        source: mrna-deconv/deconvoluted
      proteomics:
        source: prot-deconv/deconvoluted
    out:
      [corr]

  
