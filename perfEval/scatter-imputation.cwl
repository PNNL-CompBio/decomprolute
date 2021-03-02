#!/usr/bin/env cwltool
class: Workflow
label: scatter-imputation
id: scatter-imputation
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
  prot-algorithms:
    type: string[]
  signatures:
    type: File[]
      
outputs:
  prot-data:
    type: File[]
    outputSource: download-prot/matrix
  prot-data-imputed:
    type: File[]
    outputSource: impute-prot/matrix
  prot-deconvoluted:
    type: File[]
    outputSource: deconv-prot/deconvoluted
  prot-imputed-deconvoluted:
    type: File[]
    outputSource: deconv-prot-imputed/deconvoluted

steps:
  download-prot:
    run: ../protData/prot-data-cwl-tool.cwl
    scatter: [cancerType, sampleType]
    scatterMethod: flat_crossproduct
    in:
      cancerType: cancerType
      sampleType: tissueType
    out:
      [matrix]

  impute-prot:
    run: ../imputation/imputation-tool.cwl
    scatter: [input_f]
    scatterMethod: flat_crossproduct
    in:
      input_f:
        source: download-prot/matrix
      use_missForest:
        valueFrom: 'false'
    out:
      [matrix]

  deconv-prot:
    run: prot-deconv-imputed.cwl
    in:
      expression: 
        source: download-prot/matrix
      protAlg: prot-alg
      signature: signature
    out: [deconvoluted]

  deconv-prot-imputed:
    run: prot-deconv-imputed.cwl
    scatter: [expression, protAlg, signature]
    scatterMethod: flat_crossproduct
    in:
      expression:
        source: impute-prot/matrix
      protAlg: prot-alg
      signature: signature
    out: [deconvoluted]
