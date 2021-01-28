#!/usr/bin/env cwltool
class: Workflow
label: call-deconv-by-arg
id: call-deconv-by-arg
cwlVersion: v1.2

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:
   signature: File
   prot-alg: string
   cancerType: string

#outputs:
#   patient-correlation:
#     type: File
#     outputSource: patient-cor/file
#celltype-correlation:
#     type: File
#     outputSource: celltype-cor/file

steps:
  run-cibersort:
     in:
       cancerType: cancerType
       signature: signature
       protAlg: prot-alg
     run: eval-cibersort-with-correlation.cwl
     when: $(inputs.protAlg == 'cibersort')
     out: [corr]
  run-xcell:
     run: eval-xcell-with-correlation.cwl
     when: $(inputs.protAlg == 'xcell')
     in:
       cancerType: cancerType
       signature: signature
       protAlg: prot-alg
     out: [corr]

outputs:
  corr:
    type: File
    outputSource:
      - run-cibersort/corr
      - run-xcell/corr
    pickValue: first_non_null
