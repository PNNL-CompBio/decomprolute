#!/usr/bin/env cwltool
class: Workflow
label: run-deconv
id: run-deconv
cwlVersion: v1.2

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: StepInputExpressionRequirement

inputs:
   signature:
     type: File
   alg:
     type: string
   cancerType:
     type: string
   sampleType:
     type: string
   dataType:
     type: string
   matrix:
     type: File
steps:
  run-cibersort:
    run: ../tumorDeconvAlgs/cibersort/run-cibersort-tool.cwl
    when: $(inputs.alg == 'cibersort')
    in:
      expression: matrix
      signature: signature
      alg: alg
      type: dataType
      cancerType: cancerType          
    out:
      [deconvoluted]
  run-xcell:
     run: ../tumorDeconvAlgs/xcell/run-xcell-tool.cwl
     when: $(inputs.alg == 'xcell')
     in:
       signature: signature
       alg: alg
       expression: matrix
       type: dataType
       cancerType: cancerType      
     out: [deconvoluted]
  run-epic:
     run: ../tumorDeconvAlgs/epic/run-epic-tool.cwl
     when: $(inputs.alg == 'epic')
     in:
       expression: matrix
       signature: signature
       alg: alg
       type: dataType
       cancerType: cancerType             
     out: [deconvoluted]
#  run-cibersortx:
#     run: ../tumorDeconvAlgs/cibersortx/run-cibersortx-tool.cwl
#     when: $(inputs.alg == 'cibersortx')
#     in:
#       signature: signature
#       alg: alg
#       type: dataType
#       cancerType: cancerType      
 #      expression: matrix
#     out: [deconvoluted]
  run-mcpcounter:
     run: ../tumorDeconvAlgs/mcpcounter/run-mcpcounter-tool.cwl
     when: $(inputs.alg == 'mcpcounter')
     in:
       expression: matrix
       signature: signature
       alg: alg
       type: dataType
       cancerType: cancerType       
     out: [deconvoluted]
  run-repbulk:
    run: ../tumorDeconvAlgs/BayesDeBulk/bayes-de-bulk.cwl
    when: $(inputs.alg == 'bayesdebulk')
    in:
      expressionFile: matrix
      signatureMatrix: signature
      alg: alg
      dataType: dataType
      cancerType: cancerType
    out:
      [deconvoluted]
  
outputs:
  deconvoluted:
    type: File
    outputSource:
      - run-cibersort/deconvoluted
      - run-xcell/deconvoluted
 #     - run-cibersortx/deconvoluted
      - run-epic/deconvoluted
      - run-mcpcounter/deconvoluted
      - run-repbulk/deconvoluted
    pickValue: first_non_null