#!/usr/bin/env cwltool
class: Workflow
label: manual-deconv-and-cor
id: manual-deconv-and-cor
cwlVersion: v1.2

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement
  
inputs:
   signature: File
   mrna-alg: string
   prot-alg: string
   mrna-file: File
   prot-file: File
   cancerType: string
   tissueType: string

outputs:
  pat-cor-file:
     type: File
     outputSource: patient-cor/corr
  cell-cor-file:
     type: File
     outputSource: celltype-cor/corr
  mat-dist-file:
     type: File
     outputSource: matrix-distance/dist

steps:
  deconv-mrna:
     run: ../../tumorDeconvAlgs/run-deconv.cwl
     in:
       alg: mrna-alg
       signature: signature
       matrix: mrna-file
     out: [deconvoluted]
  deconv-prot:
     run: ../../tumorDeconvAlgs/run-deconv.cwl
     in:
       alg: prot-alg
       signature: signature
       matrix: prot-file
     out: [deconvoluted]
  patient-cor:
     run: ../correlations/deconv-corr-cwl-tool.cwl
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
