#!/usr/bin/env cwltool
class: Workflow
label: simul-data-comparison
id: simul-data-comparison
cwlVersion: v1.2

requirements:
   - class: SubworkflowFeatureRequirement
   - class: MultipleInputFeatureRequirement
   - class: ScatterFeatureRequirement
   - class: StepInputExpressionRequirement
   - class: InlineJavascriptRequirement

inputs: 
   reps:
      type: string[]
   prot-algorithms:
      type: string[]
   signatures:
      type: File[]
   simTypes: 
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
   cell-cors:
      type: File[]
      outputSource: run-all-algs-by-sig/cell-cor-file
   dist-files:
      type: File[]
      outputSource: run-all-algs-by-sig/mat-dist-file

steps:
   run-all-algs-by-sig:
     run: call-deconv-on-sim.cwl
     scatter: [protAlg,permutation,simType,signature]
     scatterMethod: flat_crossproduct
     in:
        protAlg: prot-algorithms
        permutation: reps
        signature: signatures
        sampleType:
          valueFrom: 'normal'
        dataType:
          valueFrom: 'prot'
        simType: simTypes
     out:
        [pat-cor-file,cell-cor-file,mat-dist-file]
   get-patient-cors:
      run: ../figures/plot-figs.cwl
      in:
        metricType:
           valueFrom: "sample"
        files: run-all-algs-by-sig/pat-cor-file
      out:
        [table,fig]
   get-celltype-cors:
      run: ../figures/plot-figs.cwl
      in:
        metricType:
            valueFrom: "cellType"
        files:
            source: run-all-algs-by-sig/cell-cor-file
      out:
         [table,fig]
