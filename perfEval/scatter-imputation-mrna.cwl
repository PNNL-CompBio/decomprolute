#!/usr/bin/env cwltool
class: Workflow
label: scatter-imputation-mrna
id: scatter-imputation-mrna
cwlVersion: v1.2


requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement

   
inputs:
  tissueTypes:
    type: string[]
  cancerTypes:
    type: string[]
  algorithms:
    type: string[]
  signatures:
    type: File[]
      
outputs:
  raw-data:
    type: File[]
    outputSource: download-raw/matrix
  # imputed-data:
  #   type: File[]
  #   outputSource: impute-data/matrix
  deconvoluted:
    type: File[]
    outputSource: deconv-raw/deconvoluted
  # imputed-deconvoluted:
  #   type: File[]
  #   outputSource: imputed-deconvolution/deconvoluted

steps:
  download-raw:
    run: ../mRNAData/mrna-data-cwl-tool.cwl
    scatter: [cancerType, sampleType]
    scatterMethod: flat_crossproduct
    in:
      cancerType: cancerTypes
      sampleType: tissueTypes
    out:
      [matrix]

  # impute-data:
  #   run: ../imputation/imputation-tool.cwl
  #   scatter: [input_f]
  #   scatterMethod: flat_crossproduct
  #   in:
  #     input_f:
  #       source: download-raw/matrix
  #     use_missForest:
  #       valueFrom: 'false'
  #   out:
  #     [matrix]

  deconv-raw:
    run: deconv-imputed.cwl
    scatter: [expression, alg, signature]
    scatterMethod: flat_crossproduct
    in:
      expression: 
        source: download-raw/matrix
      alg: algorithms
      signature: signatures
    out: [deconvoluted]

  # imputed-deconvolution:
  #   run: deconv-imputed.cwl
  #   scatter: [expression, alg, signature]
  #   scatterMethod: flat_crossproduct
  #   in:
  #     expression:
  #       source: impute-data/matrix
  #     alg: algorithms
  #     signature: signatures
  #   out: [deconvoluted]
