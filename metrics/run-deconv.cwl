#!/usr/bin/env cwltool
class: Workflow
label: run-deconv
id: run-deconv
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
   matrix:
     type: File
     
steps:
  run-cibersort:
     run: ../tumorDeconvAlgs/cibersort/run-cibersort-tool.cwl
     when: $(inputs.alg == "cibersort")
     in:
      expression: matrix
      signature: signature
      alg: alg
     out: [deconvoluted]
  run-xcell:
     run: ../tumorDeconvAlgs/xcell/run-xcell-tool.cwl
     when: $(inputs.alg == "xcell")
     in:
       expression: matrix
       signature: signature
       alg: alg
     out: [deconvoluted]
  run-epic:
     run: ../tumorDeconvAlgs/epic/run-epic-tool.cwl
     when: $(inputs.alg == "epic")
     in:
       expression: matrix
       signature: signature
       alg: alg
     out: [deconvoluted]
#  run-cibersortx:
#     run: ../tumorDeconvAlgs/cibersortx/run-cibersortx-tool.cwl
#     when: $(inputs.alg == "cibersortx")
#     in:
#       expression: matrix
#       signature: signature
#       alg: alg
#     out: [deconvoluted]
  run-mcpcounter:
     run: ../tumorDeconvAlgs/mcpcounter/run-mcpcounter-tool.cwl
     when: $(inputs.alg == "mcpcounter")
     in:
       expression: matrix
       signature: signature
       alg: alg
     out: [deconvoluted]
  run-bayesdebulk:
    run: ../tumorDeconvAlgs/BayesDeBulk/run-bayesdebulk-tool.cwl
    when: $(inputs.alg == "bayesdebulk")
    in:
      expression: matrix
      signature: signature
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
      - run-bayesdebulk/deconvoluted
    pickValue: first_non_null
