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
   prot-alg:
     type: string
   sampleType:
     type: string
     default: 'normal'
   dataType:
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

steps:
  get-sim-data:
     run: ../simulatedData/sim-data-tool.cwl
     in:
       repNumber: permutation
     out:
       [matrix,cellType]
  deconv-prot:
     run: run-deconv.cwl
     in:
       alg: prot-alg
       signature: signature
       cancerType: permutation
       sampleType: sampleType          
       dataType: dataType
       matrix: get-sim-data/matrix
     out: [deconvoluted]
  patient-cor:
     run: ./correlations/deconv-corr-cwl-tool.cwl
     in:
       cancerType: permutation
       mrnaAlg:
         valueFrom: 'cellFraction'
       protAlg: prot-alg
       signature: signature
       sampleType: sampleType
       proteomics:
         source: deconv-prot/deconvoluted
       transcriptomics:
         source: get-sim-data/cellType
     out: [corr]
  celltype-cor:
     run: ./correlations/deconv-corrXcelltypes-cwl-tool.cwl
     in:
       cancerType: permutation
       mrnaAlg:
          valueFrom: "cellFraction"
       protAlg: prot-alg
       signature: signature
       sampleType: sampleType
       proteomics:
         source: deconv-prot/deconvoluted
       transcriptomics:
         source: get-sim-data/cellType
     out: [corr]
