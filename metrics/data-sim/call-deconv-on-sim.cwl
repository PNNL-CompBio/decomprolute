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
   signature:
     type: File
   protAlg:
     type: string
   permutation:
     type: string
     default: '1'
   dataType:
     type: string
     default: 'prot'
   simType:
     type: string
     default: 'prot'

outputs:
  matrix:
     type: File
     outputSource: get-sim-data/matrix
  cellPred:
     type: File
     outputSource: get-sim-data/cellType
  deconvoluted:
     type: File
     outputSource: deconv-prot/deconvoluted
  deconv:
     type: File
     outputSource: match-prot-to-sig/updated-deconv
  mat-dist-file:
     type: File
     outputSource: matrix-distance/dist     
  cell-cor-file:
     type: File
     outputSource: celltype-cor/corr

steps:
  get-sim-data:
     run: ../../simulatedData/sim-data-tool.cwl
     in:
       repNumber: permutation
       simType: simType
     out:
       [matrix,cellType]
  deconv-prot:
     run: ../run-deconv.cwl
     in:
       alg: protAlg
       signature: signature
       matrix: get-sim-data/matrix
     out: [deconvoluted]
  match-prot-to-sig:
     run: ../../simulatedData/map-sig-tool.cwl
     in:
       deconv-matrix: deconv-prot/deconvoluted
       sig-matrix: signature
       deconv-type: simType
       cell-matrix: get-sim-data/cellType
     out: [updated-deconv,updated-cell-matrix]
  celltype-cor:
     run: ../correlations/deconv-corrXcelltypes-cwl-tool.cwl
     in:
       cancerType: permutation
       mrnaAlg:
          valueFrom: "cellFraction"
       protAlg: protAlg
       signature: signature
       sampleType: simType
       proteomics:
         source: match-prot-to-sig/updated-deconv
       transcriptomics:
         source: match-prot-to-sig/updated-cell-matrix
     out: [corr]
  matrix-distance:
     run: ../comparison/deconv-comparison-tool.cwl
     in:
       matrixA: match-prot-to-sig/updated-deconv
       matrixB: match-prot-to-sig/updated-cell-matrix 
       cancerType: permutation
       aAlg: protAlg
       bAlg:
         valueFrom: "cellFraction"
       signature: signature
       sampleType: simType
     out:
       [dist]
