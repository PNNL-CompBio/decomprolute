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
   signature: string
   mrna-alg: string
   prot-alg: string
   cancerType: string
   tissueType: string
   mrna-file: File
   prot-file: File

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
  get-sig:
      run: ../signature_matrices/get-signature-matrix.cwl
      in:
        sigMatrixName: signature
      out:
        [sigMatrix]
  deconv-mrna:
      run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/main/tumorDeconvAlgs/run-deconv.cwl
      in:
        signature: get-sig/sigMatrix
        alg: mrna-alg
        matrix: mrna-file
#            valueFrom: "../$(inputs.cancerType)-tumor-mrna-raw.tsv"
      out:
        [deconvoluted]
  deconv-prot:
      run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/main/tumorDeconvAlgs/run-deconv.cwl
      in:
        signature: get-sig/sigMatrix
        alg: prot-alg
        matrix: prot-file
        #valueFrom: "../$(inputs.cancerType)-tumor-prot-raw.tsv"
      out:
        [deconvoluted]
  patient-cor:
     run: ../metrics/correlations/deconv-corr-cwl-tool.cwl
     in:
       cancerType: cancerType
       mrnaAlg: mrna-alg
       protAlg: prot-alg
       signature: get-sig/sigMatrix
       sampleType: tissueType
       proteomics:
         source: deconv-prot/deconvoluted
       transcriptomics:
         source: deconv-mrna/deconvoluted
     out: [corr]
  celltype-cor:
     run: ../metrics/correlations/deconv-corrXcelltypes-cwl-tool.cwl
     in:
       cancerType: cancerType
       mrnaAlg: mrna-alg
       protAlg: prot-alg
       signature: get-sig/sigMatrix
       sampleType: tissueType
       proteomics:
         source: deconv-prot/deconvoluted
       transcriptomics:
         source: deconv-mrna/deconvoluted
     out: [corr]
  matrix-distance:
     run: ../metrics/distance/deconv-comparison-tool.cwl
     in:
       matrixA: deconv-mrna/deconvoluted
       matrixB: deconv-prot/deconvoluted
       cancerType: cancerType
       aAlg: mrna-alg
       bAlg: prot-alg
       signature: get-sig/sigMatrix
       sampleType: tissueType
     out:
       [dist]
