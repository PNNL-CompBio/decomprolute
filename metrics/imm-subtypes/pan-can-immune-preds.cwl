#!/usr/bin/env cwltool
class: Workflow
label: pan-can-immune-pred
id: pan-can-immune-pred
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
  fig:
     type: File[]
  table:
     type: File

steps:
  call-deconv:
    run: ../prot-deconv.cwl
    scatter: [signature,protAlg,cancerType,sampleType]
    scatterMethod: flat_crossproduct
    in:
      cancerType: cancerTypes
      signature: signatures
      protAlg: prot-algorithms
      sampleType: tissueTypes
    out:
      [deconvoluted]
  plot-imm:
    run: plot-immune-subtypes.cwl
    in:
      files: call-deconv/deconvoluted
    out:
      [table,fig]
      
