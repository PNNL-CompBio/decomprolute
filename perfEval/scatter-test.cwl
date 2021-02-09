#!/usr/bin/env cwltool

class: Workflow
label: scatter-test
id: scatter-test
cwlVersion: v1.2


requirements:
   - class: SubworkflowFeatureRequirement
   - class: MultipleInputFeatureRequirement
   - class: ScatterFeatureRequirement
   - class: StepInputExpressionRequirement
   
inputs:
   cancerTypes:
      type: string[]
   prot-algorithms:
      type: string[]
   mrna-algorithms:
      type: string[]
   signatures:
      type: File[]
   tissue-types:
      type: string[]
      
outputs:
   pat-cor-tab:
        type: File
        outputSource: get-patient-cors/table
   pat-fig:
        type: File[]
        outputSource: get-patient-cors/fig
   cell-cor-tab:
        type: File
        outputSource: get-celltype-cors/table
   cell-fig:
        type: File[]
        outputSource: get-celltype-cors/fig
   mrna-files:
        type: File[]
        outputSource: run-all-algs-by-sig/mrna-file
   prot-files:
        type: File[]
        outputSource: run-all-algs-by-sig/prot-file

steps:
    run-all-algs-by-sig:
       run: call-deconv-and-cor.cwl
       scatter: [signature,mrna-alg,prot-alg,cancerType,tissue-type]
       scatterMethod: flat_crossproduct
       in:
         signature: signatures
         prot-alg: prot-algorithms
         mrna-alg: mrna-algorithms
         cancerType: cancerTypes
         tissue-type: tissue-types
       out:
         [pat-cor-file,cell-cor-file,prot-file,mrna-file]
    get-patient-cors:
        run: figures/plot-figs.cwl
        in:
          sampOrCell:
             valueFrom: "sample"
          files: run-all-algs-by-sig/pat-cor-file
        out:
          [table,fig]
    get-celltype-cors:
        run: figures/plot-figs.cwl
        in:
          sampOrCell:
              valueFrom: "cellType"
          files:
              source: run-all-algs-by-sig/cell-cor-file
        out:
          [table,fig]
