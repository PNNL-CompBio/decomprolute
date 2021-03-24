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
   cancerType:
     type: string
     default: 'simulated'

outputs:
  pat-cor-file:
     type: File
     outputSource: patient-cor/corr
  cell-cor-file:
     type: File
     outputSource: celltype-cor/corr


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
       cancerType: cancerType
       sampleType: sampleType          
       dataType: dataType
       matrix: get-sim-data/matrix
     out: [deconvoluted]
  patient-cor:
     run: ./correlations/deconv-corr-cwl-tool.cwl
     in:
       cancerType: dataType
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
       cancerType: dataType
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
