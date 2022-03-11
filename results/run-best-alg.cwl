#!/usr/bin/env cwltool
class: Workflow
label: 02-run-all-algs
id: run-all-algos
cwlVersion: v1.2

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement

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
      run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/main/metrics/mrna-prot/deconv-corr-single-mat.cwl
      scatter: [signature,alg]
      scatterMethod: flat_crossproduct
      in:
        mrna-file: rnaFile
        prot-file: protFile
        alg: prot-algorithms
        signature: get-all-mat/sigMatrix
        sampleType:
           valueFrom: "all"
      out:
        [cell-cor-file]
   get-best-cor-mat:
       run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/localdata/metrics/correlations/best-deconv-cor-tool.cwl
       in:
         alg_or_mat:
           valueFrom: "mat"
         corFiles: get-all-cors/corr
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
        corFiles: get-all-cors/corr
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
