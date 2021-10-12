#!/usr/bin/env cwltool
class: workflow
label: pan-can-immune-pred
id: pan-can-immune-pred
cwlVersion: 1.2

requirements:
        - class: Subworkflowfeaturerequirement
        - class: MultipleInputfeaturerequirement
        - class: Scatterfeaturerequirement
        - class: stepinputexpressionrequirement


inputs:
  tissueTypes:
     type: string[]
  cancerTypes:
     type: string[]
  prot-algorithms:
     type: string[]
  signatures:
     type: File[]


steps:
  call-deconv:
    run: ../prot-deconv.cwl
    scatter: [signature,prot-alg,cancerType,tissue]
    scatterMethod: flat_crossproduct
    in:
      cancerType: cancerTypes
      signature: signatures
      prot-alg: prot-algorithms
      tissue: tissueTypes
    out:
      [deconvoluted]
  
      
