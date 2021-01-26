#!/usr/bin/env cwltool

class: Workflow
label: call-deconv-by-arg
id: call-deconv-by-arg
cwlVersion: v1.2

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement


inputs:
   signature:
     type: File
   prot-alg:
     type: string
#   mrna-alg:
#     type: string
   cancerType:
     type: string

outputs:
   patient-correlation:
     type: File
     outputSource: patient-cor/file
   celltype-correlation:
     type: File
     outputSource: celltype-cor/file

steps:
  run-alg-with-params:
        run: ../tumorDeconvAlgs/cibersort/run-cibersort-tool.cwl
        when: $(intput.prot-alg='cibersort')
        in:
          cancerType: inputs/cancerType
          signature: inputs/signature

        output
