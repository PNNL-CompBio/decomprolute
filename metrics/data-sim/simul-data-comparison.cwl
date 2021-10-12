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
   cell-cor-tab:
      type: File
      outputSource: get-celltype-cors/table
   cell-fig:
      type: File[]
      outputSource: get-celltype-cors/fig
   dist-fig:
      type: File[]
      outputSource: get-distances/fig
   dist-tab:
      type: File
      outputSource: get-distances/table
   

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
        [cell-cor-file,mat-dist-file, deconv, cellPred, deconvoluted, matrix]
   get-celltype-cors:
      run: ../figures/plot-figs.cwl
      in:
        metricType:
            valueFrom: "cellType"
        files:
            source: run-all-algs-by-sig/cell-cor-file
      out:
         [table,fig]
#   get-celltype-cordists:
#      run: ../figures/plot-figs.cwl
#      in:
#        metric:
#            valueFrom: "meanCorrelation"
#        metricType:
#            valueFrom: "cellType"
#        files:
#            source: run-all-algs-by-sig/cell-cor-file
#      out:
#         [table,fig]
   get-distances:
      run: ../figures/plot-figs.cwl
      in:
         metric:
            valueFrom: "distance"
         metricType:
            valueFrom: "cellType"
         files:
            source: run-all-algs-by-sig/mat-dist-file
      out:
         [table,fig]
