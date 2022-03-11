#!/usr/bin/env cwltool
class: Workflow
label: 02-run-all-algs
id: run-all-algos
cwlVersion: v1.2

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
<<<<<<< HEAD
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
=======
  - class: InlineJavascriptRequirement
  
inputs:
   signature: File
   alg: string
   mrna-file: File
   prot-file: File
   cancerType: string
   tissueType: string
>>>>>>> 6cd75777c329fd2bfd39a21479544c9d98e4e600

inputs:
   signatures:
     type: string[]
   prot-algorithms:
     type: string[]
   protFile:
     type: File
   rnaFile:
     type: File

outputs:
   deconvoluted:
     type: File
     outputSource:
      - run-best-algs-by-sig/deconvoluted

steps:
<<<<<<< HEAD
   get-all-mat:
      run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/main/signature_matrices/get-signature-matrix.cwl
      #./../proteomicsTumorDeconv/signature_matrices/get-signature-matrix.cwl
      scatter: [sigMatrixName]
      scatterMethod: flat_crossproduct
      in:
        sigMatrixName: signatures
      out:
        [sigMatrix]
   get-all-cors:
      run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/localdata/metrics/mrna-prot/deconv-cor-single-mat.cwl
      scatter: [signature,alg]
      scatterMethod: flat_crossproduct
      in:
        mrna-file: rnaFile
        prot-file: protFile
        alg: prot-algorithms
        signature: get-all-mat/sigMatrix
        cancerType:
          valueFrom: "AML"
        tissueType:
          valueFrom: "all"
      out:
        [cell-cor-file,mat-dist-file,mrna-deconv,pat-cor-file,prot-deconv]
   get-best-cor-mat:
       run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/localdata/metrics/correlations/best-deconv-cor-tool.cwl
       in:
         alg_or_mat:
           valueFrom: "mat"
         corFiles: get-all-cors/cell-cor-file
       out:
         [value]
   get-best-mat:
       run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/main/signature_matrices/get-signature-matrix.cwl
       in:
          sigMatrixName: get-best-cor-mat/value
       out:
          [sigMatrix]
   get-best-cor-alg:
      run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/localdata/metrics/correlations/best-deconv-cor-tool.cwl
      in:
        alg_or_mat:
          valueFrom: "alg"
        corFiles: get-all-cors/cell-cor-file
      out:
        [value]
   run-best-algs-by-sig:
      run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/localdata/metrics/run-deconv.cwl
      in:
        signature: get-best-mat/sigMatrix
        alg: get-best-cor-alg/value
        matrix: protFile
      out:
        [deconvoluted]
=======
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
       signature: signature
       sampleType: tissueType
     out:
       [dist]
>>>>>>> 6cd75777c329fd2bfd39a21479544c9d98e4e600
