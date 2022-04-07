#!/usr/bin/env cwltool
class: Workflow
label: run-best-alg-by-sim
id: run-best-alg-by-sim
cwlVersion: v1.1

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement

inputs:
   algorithms:
     type: string[]
   data-type: ##evaluate mRNA or protein
     type: string
   datFile:
     type: File
   cancerType:
     type: string
   tissueType:
     type: string

outputs:
   deconvoluted:
     type: File   
     outputSource:
      - run-best-algs-by-sig/deconvoluted

steps:
   get-all-cors:
      run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/main/metrics/data-sim/simul-data-comparison.cwl
      in:
        prot-algorithms: algorithms
        simType: data-type
      out:
        [cell-cor-tab,cell-fig]
   get-best-cor-mat:
       run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/main/metrics/correlations/best-deconv-cor-tool.cwl
       in:
         alg_or_mat:
           valueFrom: "mat"
         corFiles: get-all-cors/cell-cor-file
       out:
         [value]
   get-best-alg:
       run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/main/signature_matrices/get-signature-matrix.cwl
       in:
          sigMatrixName: get-best-cor-mat/value
       out:
          [sigMatrix]
   get-best-cor-alg:
      run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/main/metrics/correlations/best-deconv-cor-tool.cwl
      in:
        alg_or_mat:
          valueFrom: "alg"
        corFiles: get-all-cors/cell-cor-file
      out:
        [value]
   run-best-algs-by-sig:
      run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/main/tumorDeconvAlgs/run-deconv.cwl
      in:
        signature: get-best-mat/sigMatrix
        alg: get-best-cor-alg/value
        matrix: protFile
      out:
        [deconvoluted]
