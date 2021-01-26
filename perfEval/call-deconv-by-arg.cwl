#!/usr/bin/env cwltool

class: Workflow
label: call-deconv-by-arg
id: call-deconv-by-arg
cwlVersion: v1.2

requirements:
  -class: SubworkflowFeatureRequirement
  -class: MultipleInputFeatureRequirement


inputs:
   signature:
     type: File
   prot-alg:
     type: string
   mrna-alg:
     type: string
   cacnerType:
     type: string

outputs:
   patient-correlation:
   celltype-correlation:


steps:
  
