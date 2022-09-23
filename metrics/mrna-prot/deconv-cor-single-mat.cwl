#!/usr/bin/env cwltool
class: Workflow
label: deconv-cor-single-mat 
id: deconv-cor-single-mat
cwlVersion: v1.2

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  
inputs:
   signature:
     type: string
   alg:
     type: string
   protFile:
     type: File
   rnaFile:
     type: File
   cancerType:
     type: string
   tissueType:
     type: string
     default: "all"

outputs:
   cell-cor-file:
     type: File
     outputSource:
      - celltype-cor/corr
   pat-cor-file:
     type: File
     outputSource:
      - patient-cor/corr
   mat-dist-file:
     type: File
     outputSource:
      - matrix-distance/dist
   mrna-file:
     type: File
     outputSource:
      - deconv-mrna/deconvoluted
   prot-file:
     type: File
     outputSource:
       - deconv-prot/deconvoluted
steps:
   get-mat:
      run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/main/signature_matrices/get-signature-matrix.cwl
      in:
        sigMatrixName: signature
      out:
        [sigMatrix]
   deconv-mrna:
      run: ../../tumorDeconvAlgs/run-deconv.cwl
      in:
        matrix: rnaFile
        signature: get-mat/sigMatrix
        alg: alg
      out: [deconvoluted]
   deconv-prot:
      run: ../../tumorDeconvAlgs/run-deconv.cwl
      in:
        matrix: protFile
        signature: get-mat/sigMatrix
        alg: alg
      out: [deconvoluted]
   patient-cor:
      run: ../correlations/deconv-corr-cwl-tool.cwl
      in:
        cancerType: cancerType
        mrnaAlg: alg
        protAlg: alg
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
        mrnaAlg: alg
        protAlg: alg
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
        aAlg: alg
        bAlg: alg
        signature: get-mat/sigMatrix
        sampleType: tissueType
      out:
        [dist]
