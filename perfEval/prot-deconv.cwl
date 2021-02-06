#!/usr/bin/env cwltool
class: Workflow
label: prot-deconv
id: prot-deconv
cwlVersion: v1.2

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: StepInputExpressionRequirement

inputs:
   signature:
     type: File
   protAlg:
     type: string
   cancerType:
     type: string

steps:
  download-prot:
    run: ../protData/prot-data-cwl-tool.cwl
    in:
      cancerType: cancerType
    out:
      [matrix]
  run-cibersort:
    run: ../tumorDeconvAlgs/cibersort/run-cibersort-tool.cwl
    when: $(inputs.protAlg == 'cibersort')
    in:
      expression:
        source: download-prot/matrix
      signature: signature
      protAlg: protAlg
      type:
        valueFrom: 'prot'
      cancerType: cancerType          
      protAlg: protAlg    
    out:
      [deconvoluted]
  run-xcell:
     run: ../tumorDeconvAlgs/xcell/run-xcell-tool.cwl
     when: $(inputs.protAlg == 'xcell')
     in:
       signature: signature
       protAlg: protAlg
       expression:
         source: download-prot/matrix
       type:
         valueFrom: 'prot'
       cancerType: cancerType      
     out: [deconvoluted]
  run-epic:
     run: ../tumorDeconvAlgs/epic/run-epic-tool.cwl
     when: $(inputs.protAlg == 'epic')
     in:
       expression:
         source: download-prot/matrix
       signature: signature
       protAlg: protAlg
       type:
         valueFrom: 'prot'
       cancerType: cancerType             
     out: [deconvoluted]
#  run-cibersortx:
#     run: ../tumorDeconvAlgs/cibersortx/run-cibersortx-tool.cwl
#     when: $(inputs.protAlg == 'cibersortx')
#     in:
#       signature: signature
#      progAlg: protAlg
#     type:
#        valueFrom: 'prot'
#      cancerType: cancerType      
#       expression:
#        source: download-prot/matrix
#     out: [deconvoluted]
  run-mcpcounter:
     run: ../tumorDeconvAlgs/mcpcounter/run-mcpcounter-tool.cwl
     when: $(inputs.protAlg == 'mcpcounter')
     in:
       expression:
         source: download-prot/matrix
       signature: signature
       protAlg: protAlg
       type:
         valueFrom: 'prot'
       cancerType: cancerType       
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
