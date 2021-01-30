#!/usr/bin/env cwltool
class: Workflow
label: mrna-deconv
id: mrna-deconv
cwlVersion: v1.2

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:
   signature:
      type: File
   mrnaAlg:
      type: string
   cancerType:
      type: string

steps:
  download-mrna:
    run: ../mRNAData/mrna-data-cwl-tool.cwl
    in:
      cancerType: cancerType
    out:
      [matrix]
  run-cibersort:
    run: ../tumorDeconvAlgs/cibersort/run-cibersort-tool.cwl
    when: $(inputs.mrnaAlg == 'cibersort')
    in:
      expression:
        source: download-mrna/matrix
      signature: signature
      mrnaAlg: mrnaAlg
    out:
      [deconvoluted]
  run-xcell:
    run: ../tumorDeconvAlgs/xcell/run-xcell-tool.cwl
    when: $(inputs.mrnaAlg == 'xcell')
    in:
      signature: signature
      expression:
        source: download-mrna/matrix
      mrnaAlg: mrnaAlg
    out: [deconvoluted]
  run-epic:
    run: ../tumorDeconvAlgs/epic/run-epic-tool.cwl
    when: $(inputs.mrnaAlg == 'epic')
    in:
      expression:
        source: download-mrna/matrix
      signature: signature
      mrnaAlg: mrnaAlg
    out: [deconvoluted]
#  run-cibersortx:
#     run: ../tumorDeconvAlgs/cibersortx/run-cibersortx-tool.cwl
#     when: $(inputs.mrnaAlg == 'cibersortx')
#     in:
#       signature: signature
#       expression:
#        source: download-mrna/matrix
#       mrnaAlg: mrnaAlg
#     out: [deconvoluted]
  run-mcpcounter:
    run: ../tumorDeconvAlgs/mcpcounter/run-mcpcounter-tool.cwl
    when: $(inputs.mrnaAlg == 'mcpcounter')
    in:
      expression:
        source: download-mrna/matrix
      signature: signature
      mrnaAlg: mrnaAlg       
    out: [deconvoluted]
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
