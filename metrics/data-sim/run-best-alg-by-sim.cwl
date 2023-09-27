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
   data-type: ##evaluate mRNA or protein
     type: string
   datFile:
     type: File

outputs:
   deconvoluted:
     type: File   
     outputSource:
      - run-best-algs-by-sig/deconvoluted

steps:
   compare-cors:
      run: simul-data-comparison.cwl
      in:
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
       run: ../../signature_matrices/get-signature-matrix.cwl
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
      run: ../../tumorDeconvAlgs/run-deconv.cwl
      in:
        signature: get-mat/sigMatrix
        alg: get-best-sim-alg/value
        matrix: datFile
      out:
        [deconvoluted]
