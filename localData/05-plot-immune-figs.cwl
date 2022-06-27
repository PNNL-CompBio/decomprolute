#!/usr/bin/env cwltool
class: Workflow
label: local-immune
id: local-immune
cwlVersion: v1.2

requirements:
   - class: SubworkflowFeatureRequirement
   - class: MultipleInputFeatureRequirement
   - class: ScatterFeatureRequirement
   - class: StepInputExpressionRequirement

inputs:
   cancerTypes:
      type: string[]
   algorithms:
      type: string[]
   prot-files:
      type: File[]
   signatures:
      type: string[]
      
outputs:
  fig:
     type: File[]
     outputSource: plot-imm/fig
  table:
     type: File
     outputSource: plot-imm/table

steps:
   run-algs-on-files:
     run: 06-local-rename-deconv.cwl
     scatter: [prot-file,cancerType]
     scatterMethod: dotproduct
     in:
        prot-file: prot-files
        algorithms: algorithms
        cancerType: cancerTypes
        signatures: signatures
     out:
        [deconv-file]
   plot-imm:
     run: ../metrics/imm-subtypes/plot-immune-subtypes.cwl
     in:
        files:
          valueFrom: run-algs-on-files/deconv-file
     out:
       [table,fig]

