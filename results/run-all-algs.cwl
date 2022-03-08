#!/usr/bin/env cwltool
class: Workflow
label: run-all-algs
id: run-all-algos
cwlVersion: v1.2

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement

inputs:
   signatures:
     type: string[]
   prot-algorithms:
     type: string[]
   mrna-algorithms:
     type: string[]
   cancer-types:
     type: string[]

outputs:
  pat-cor-file:
     type: File
     outputSource: patient-cor/corr
  cell-cor-file:
     type: File
     outputSource: celltype-cor/corr
  mrna-file:
     type: File
     outputSource: deconv-mrna/deconvoluted
  prot-file:
     type: File
     outputSource: deconv-prot/deconvoluted
  mat-dist-file:
     type: File
     outputSource: matrix-distance/dist
 

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
   run-all-algs-by-sig:
      run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/main/metrics/run-deconv.cwl
      #./../proteomicsTumorDeconv/metrics/run-deconv.cwl
      scatter: [signature,alg]
      scatterMethod: flat_crossproduct    
      in:
        signature: get-all-mat/sigMatrix
        alg: prot-algorithms
        matrix: inFile
      out:
        [deconvoluted]
