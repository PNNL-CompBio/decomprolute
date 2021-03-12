#!/usr/bin/env cwltool
class: Workflow
label: deconv-imputed
id: deconv-imputed
cwlVersion: v1.2

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement

inputs:
  signature:
    type: File
  alg:
    type: string
  expression:
    type: File
  
steps:
  run-cibersort:
    run: ../tumorDeconvAlgs/cibersort/run-cibersort-tool.cwl
    when: $(inputs.alg == 'cibersort')
    in:
      expression: expression
      signature: signature
      alg: alg
    out:
      [deconvoluted]
  run-xcell:
     run: ../tumorDeconvAlgs/xcell/run-xcell-tool.cwl
     when: $(inputs.alg == 'xcell')
     in:
       signature: signature
       alg: alg
       expression: expression
     out: [deconvoluted]
  run-epic:
     run: ../tumorDeconvAlgs/epic/run-epic-tool.cwl
     when: $(inputs.alg == 'epic')
     in:
       expression: expression
       signature: signature
       alg: alg
     out: [deconvoluted]
#  run-cibersortx:
#     run: ../tumorDeconvAlgs/cibersortx/run-cibersortx-tool.cwl
#     when: $(inputs.alg == 'cibersortx')
#     in:
#       signature: signature
#       progAlg: alg
#       expression: expression
#     out: [deconvoluted]
  run-mcpcounter:
     run: ../tumorDeconvAlgs/mcpcounter/run-mcpcounter-tool.cwl
     when: $(inputs.alg == 'mcpcounter')
     in:
       expression: expression
       signature: signature
       alg: alg
     out: [deconvoluted]
  run-repbulk:
    run: ../tumorDeconvAlgs/repBulk/rep-bulk.cwl
    when: $(inputs.alg == 'repbulk')
    in:
      expressionFile: expression
      signatureMatrix: signature
      alg: alg
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
    pickValue: first_non_null
