#!/usr/bin/env cwltool
class: Workflow
label: call-deconv-and-cor
id: call-deconv-and-cor
cwlVersion: v1.2

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement
  
inputs:
   signature: File
   prot-alg: string
   cancerType: string
   tissueType: string

outputs:
  pat-cor-file:
     type: File
     outputSource: patient-cor/corr
  cell-cor-file:
     type: File
     outputSource: celltype-cor/corr
  prot-file:
     type: File
     outputSource: deconv-prot/deconvoluted
  prot-file-imputed:
     type: File
     outputSource: deconv-prot-imputed/deconvoluted

steps:
  deconv-prot-imputed:
     run: prot-deconv-imputed.cwl
     in:
       cancerType: cancerType
       protAlg: prot-alg
       signature: signature
       sampleType: tissueType
     out: [deconvoluted]
  deconv-prot:
     run: prot-deconv.cwl
     in:
       cancerType: cancerType
       protAlg: prot-alg
       signature: signature
       sampleType: tissueType
     out: [deconvoluted]
  patient-cor:
     run: ./correlations/deconv-corr-cwl-tool.cwl
     in:
       cancerType: cancerType
       mrnaAlg: prot-alg
       protAlg: prot-alg
       signature: signature
       sampleType: tissueType
       proteomics:
         source: deconv-prot/deconvoluted
       transcriptomics:
         source: deconv-prot-imputed/deconvoluted
     out: [corr]
  celltype-cor:
     run: ./correlations/deconv-corrXcelltypes-cwl-tool.cwl
     in:
       cancerType: cancerType
       mrnaAlg: prot-alg
       protAlg: prot-alg
       signature: signature
       sampleType: tissueType
       proteomics:
         source: deconv-prot/deconvoluted
       transcriptomics:
         source: deconv-prot-imputed/deconvoluted
     out: [corr]