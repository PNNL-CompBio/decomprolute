#!/usr/bin/env cwltool
class: Workflow
label: call-deconv-on-sim
id: call-deconv-on-sim
cwlVersion: v1.2

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: StepInputExpressionRequirement

inputs:
   signature:  ##name of matrix to sample from
     type: string
   protAlg:    ##algorithm to run
     type: string
   simulation: ## permutation to test
     type: string
     default: '1'
   dataType:   ##mRNA or protein data
     type: string
     default: 'prot'
   simType:    ##data simulated from mrna or protein
     type: string
     default: 'prot'
   sample:     ##how much of the permuted sample do we test
     type: int
     default: 100
   sampleRep:  ##
     type: int
     default: 1

outputs:
#  matrix:
#     type: File
#     outputSource: get-sim-data/matrix
#  cellPred:
#     type: File
#     outputSource: get-sim-data/cellType
#  deconvoluted:
#     type: File
#     outputSource: deconv-prot/deconvoluted
#  deconv:
#     type: File
#     outputSource: match-prot-to-sig/updated-deconv
  cell-cor-file:
     type: File
     outputSource: celltype-cor/corr

steps:
  get-sig-mat:
     run: ../../signature_matrices/get-signature-matrix.cwl
     in:
      sigMatrixName: signature
      subsample: sample
     out:
      [sigMatrix]
  get-sim-data:
     run: ../../simulatedData/sim-data-tool.cwl
     in:
       simNumber: simulation
       simType: simType
     out:
       [matrix,cellType]
  deconv-prot:
     run: ../../tumorDeconvAlgs/run-deconv.cwl
     in:
       alg: protAlg
       signature: get-sig-mat/sigMatrix
       matrix: get-sim-data/matrix
     out: [deconvoluted]
  match-prot-to-sig:
     run: ../../simulatedData/map-sig-tool.cwl
     in:
       deconv-matrix: deconv-prot/deconvoluted
       sig-matrix: get-sig-mat/sigMatrix
       deconv-type: simType
       cell-matrix: get-sim-data/cellType
     out: [updated-deconv,updated-cell-matrix]
  celltype-cor:
     run: ../correlations/deconv-corrXcelltypes-cwl-tool.cwl
     in:
       cancerType: simulation
       mrnaAlg:
          valueFrom: "cellFraction"
       protAlg: protAlg
       signature: signature
       sampleVal: sample
       sampleType: simType
       sampleRep: sampleRep
       proteomics:
         source: match-prot-to-sig/updated-deconv
       transcriptomics:
         source: match-prot-to-sig/updated-cell-matrix
     out: [corr]
#  matrix-distance:
#     run: ../distance/deconv-comparison-tool.cwl
#     in:
#       matrixA: match-prot-to-sig/updated-deconv
#       matrixB: match-prot-to-sig/updated-cell-matrix 
#       cancerType: simulation
#       aAlg: protAlg
#       bAlg:
#         valueFrom: "cellFraction"
#       signature: get-sig-mat/sigMatrix
#       sampleType: simType
#     out:
#       [dist]
