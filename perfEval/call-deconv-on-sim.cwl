#!/usr/bin/env cwltool
class: Workflow
label: call-deconv-on-sim
id: call-deconv-on-sim
cwlVersion: v1.2

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement
  
inputs:
   signature: File
   permutation: string
   prot-alg: string

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
       repNumber: inputs/permutation
     out:
       [matrix,cellType]
  deconv-prot:
     run: prot-deconv.cwl
     in:
       cancerType: cancerType
       protAlg: prot-alg
       signature: signature
       sampleType: tissueType
     out: [deconvoluted]
  patient-cor:
     run: ./correlations/deconv-corr-cwl-tool.cwl
     in:
       cancerType: cancerType
       mrnaAlg: mrna-alg
       protAlg: prot-alg
       signature: signature
       sampleType: tissueType
       proteomics:
         source: deconv-prot/deconvoluted
       transcriptomics:
         source: deconv-mrna/deconvoluted
     out: [corr]
  celltype-cor:
     run: ./correlations/deconv-corrXcelltypes-cwl-tool.cwl
     in:
       cancerType: cancerType
       mrnaAlg: mrna-alg
       protAlg: prot-alg
       signature: signature
       sampleType: tissueType
       proteomics:
         source: deconv-prot/deconvoluted
       transcriptomics:
         source: deconv-mrna/deconvoluted
     out: [corr]
