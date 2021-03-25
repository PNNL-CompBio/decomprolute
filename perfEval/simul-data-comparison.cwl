#!/usr/bin/env cwltol
class: Workflow
label: simul-data-comparison
id: simul-data-comparison
cwlVersion: v1.2

requirements:
   - class: SubworkflowFeatureRequirement
   - class: MultipleInputFeatureRequirement
   - class: ScatterFeatureRequirement
   - class: StepInputExpressionRequirement

inputs: 
   reps:
      type: string[]
   prot-algorithms:
      type: string[]
   signature:
      type: File
      
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
   cell-cors:
      type: File[]
      outputSource: run-all-algs-by-sig/cell-cor-file

steps:
   run-all-algs-by-sig:
     run: call-deconv-on-sim.cwl
     scatter: [prot-alg,permutation]
     scatterMethod: flat_crossproduct
     in:
        prot-alg: prot-algorithms
        permutation: reps
        signature: signature
     out:
        [pat-cor-file,cell-cor-file]
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
   
