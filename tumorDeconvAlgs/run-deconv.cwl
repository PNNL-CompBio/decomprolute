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
     run: ./cibersort/run-cibersort-tool.cwl
     when: $(inputs.alg.trim() == "cibersort")
     in:
      expression: matrix
      signature: signature
      alg: alg
     out: [deconvoluted]
  run-xcell:
     run: ./xcell/run-xcell-tool.cwl
     when: $(inputs.alg.trim() == "xcell")
     in:
       expression: matrix
       signature: signature
       alg: alg
     out: [deconvoluted]
  run-epic:
     run: ./epic/run-epic-tool.cwl
     when: $(inputs.alg.trim() == "epic")
     in:
       expression: matrix
       signature: signature
       alg: alg
     out: [deconvoluted]
#WAITING CIBERSORTX UPDATE SO WE CAN TEST
#  run-cibersortx:
#     run: ./cibersortx/run-cibersortx-tool.cwl
#     when: $(inputs.alg == "cibersortx")
#     in:
#       expression: matrix
#       signature: signature
#       alg: alg
#     out: [deconvoluted]
  run-mcpcounter:
     run: ./mcpcounter/run-mcpcounter-tool.cwl
     when: $(inputs.alg.trim() == "mcpcounter")
     in:
       expression: matrix
       signature: signature
       alg: alg
     out: [deconvoluted]
  run-bayesdebulk:
    run: ./BayesDeBulk/run-bayesdebulk-tool.cwl
    when: $(inputs.alg.trim() == "bayesdebulk")
    in:
      expression: matrix
      signature: signature
      alg: alg
    out:
      [deconvoluted]
  #####ADD NEW TOOL STEP AND LINK TO TOOL BELOW
  
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
    ###ADD NEW OUTPUT FROM NEW TOOL
    pickValue: first_non_null
