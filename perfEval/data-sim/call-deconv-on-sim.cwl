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
   permutation:
     type: string
     default: '1'
   prot-alg:
     type: string
   sampleType:
     type: string
     default: 'normal'
   dataType:
     type: string
     default: 'prot'
   simType:
     type: string
     default: 'prot'

outputs:
  pat-cor-file:
     type: File
     outputSource: patient-cor/corr
  cell-cor-file:
     type: File
     outputSource: celltype-cor/corr
  deconv:
     type: File
     outputSource: deconv-prot/deconvoluted
  cellPred:
     type: File
     outputSource: get-sim-data/cellType
  mat-dist-file:
     type: File
     outputSource: matrix-distance/dist     

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
       alg: prot-alg
       signature: signature
       cancerType: permutation
       sampleType: sampleType          
       dataType: dataType
       matrix: get-sim-data/matrix
     out: [deconvoluted]
  match-prot-to-sig:
     run: ../../simulatedData/map-sig-tool.cwl
     in:
       deconv-matrix: deconv-prot/deconvoluted
       sig-matrix: signature
       cell-matrix: get-sim-data/cellType
     out: [updated-deconv]
  patient-cor:
     run: ../correlations/deconv-corr-cwl-tool.cwl
     in:
       cancerType: permutation
       mrnaAlg:
         valueFrom: 'cellFraction'
       protAlg: prot-alg
       signature: signature
       sampleType: sampleType
       proteomics:
         source: match-prot-to-sig/updated-deconv
       transcriptomics:
         source: get-sim-data/cellType
     out: [corr]
  celltype-cor:
     run: ../correlations/deconv-corrXcelltypes-cwl-tool.cwl
     in:
       cancerType: permutation
       mrnaAlg:
          valueFrom: "cellFraction"
       protAlg: prot-alg
       signature: signature
       sampleType: sampleType
       proteomics:
         source: match-prot-to-sig/updated-deconv
       transcriptomics:
         source: get-sim-data/cellType
     out: [corr]
  matrix-distance:
     run: ../comparison/deconv-comparison-tool.cwl
     in:
       matrixA: match-prot-to-sig/updated-deconv
       matrixB: get-sim-data/cellType
       cancerType: permutation
       aAlg: prot-alg
       bAlg:
         valueFrom: "cellFraction"
       signature: signature
       sampleType: sampleType
     out:
       [dist]
