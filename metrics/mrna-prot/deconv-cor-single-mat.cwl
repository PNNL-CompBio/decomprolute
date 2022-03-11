#!/usr/bin/env cwltool
class: Workflow
label: deconv-cor-single-mat
id: deconv-cor-single-mat
cwlVersion: v1.2

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement
  
inputs:
   signature: File
   alg: string
   mrna-file: File
   prot-file: File


outputs:
  pat-cor-file:
     type: File
     outputSource: patient-cor/corr
  cell-cor-file:
     type: File
     outputSource: celltype-cor/corr
  mrna-deconv:
     type: File
     outputSource: deconv-mrna/deconvoluted
  prot-deconv:
     type: File
     outputSource: deconv-prot/deconvoluted
  mat-dist-file:
     type: File
     outputSource: matrix-distance/dist

steps:
  deconv-mrna:
     run: ../run-deconv.cwl
     in:
       matrix: mrna-file
       signature: signature
       alg: alg
     out: [deconvoluted]
  deconv-prot:
     run: ../run-deconv.cwl
     in:
       matrix: prot-file
       signature: signature
       alg: alg
       sampleType: tissueType
     out: [deconvoluted]
  patient-cor:
     run: ../correlations/deconv-corr-cwl-tool.cwl
     in:
       cancerType: cancerType
       mrnaAlg: alg
       protAlg: alg
       signature: signature
       proteomics:
         source: deconv-prot/deconvoluted
       transcriptomics:
         source: deconv-mrna/deconvoluted
     out: [corr]
  celltype-cor:
     run: ../correlations/deconv-corrXcelltypes-cwl-tool.cwl
     in:
       cancerType: cancerType
       mrnaAlg: mrna-alg
       protAlg: prot-alg
       signature: signature
       sampleType: tissueType
       proteomics:
         source: deconv-prot/deconvoluted
       transcriptomics:
         source: deconv-mrna/deconvoluted
     out: [corr]
  matrix-distance:
     run: ../distance/deconv-comparison-tool.cwl
     in:
       matrixA: deconv-mrna/deconvoluted
       matrixB: deconv-prot/deconvoluted
       cancerType: cancerType
       aAlg: mrna-alg
       bAlg: prot-alg
       signature: signature
       sampleType: tissueType
     out:
       [dist]
