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
   compare-cors:
      run: simul-data-comparison.cwl
      in:
        prot-algorithms: algorithms
        simType: data-type
      out:
        [cell-cor-tab,cell-fig]
   get-best-sim-mat:
       run: ../correlations/get-best-sim.cwl
       in:
         output:
           valueFrom: "mat"
         file: compare-cors/cell-cor-tab
       out:
         [value]
   get-mat:
       run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/main/signature_matrices/get-signature-matrix.cwl
       in:
          sigMatrixName: get-best-sim-mat/value
       out:
          [sigMatrix]
   get-best-sim-alg:
      run: ../correlations/get-best-sim.cwl
      in:
        output:
          valueFrom: "alg"
        file: compare-cors/cell-cor-tab
      out:
        [value]
   run-best-algs-by-sig:
      run: https://raw.githubusercontent.com/PNNL-CompBio/proteomicsTumorDeconv/main/tumorDeconvAlgs/run-deconv.cwl
      in:
        signature: get-mat/sigMatrix
        alg: get-best-sim-alg/value
        matrix: datFile
      out:
        [deconvoluted]
