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
   tissueTypes:
      type: string[]
   cancerTypes:
      type: string[]
   prot-algorithms:
      type: string[]
   mrna-algorithms:
      type: string[]
   mrna-files:
      type: File[]
   prot-files:
      type: File[]
   signatures:
      type: string[]
      
outputs:
   sample-cor-tab:
      type: File
      outputSource: plot-sample-cors/table
   sample-fig:
      type: File[]
      outputSource: plot-sample-cors/fig
   cell-cor-tab:
      type: File
      outputSource: plot-celltype-cors/table
   cell-fig:
      type: File[]
      outputSource: plot-celltype-cors/fig
   dist-fig:
      type: File[]
      outputSource: plot-distances/fig
   dist-tab:
      type: File
      outputSource: plot-distances/table
   # cell-cor-file:
   #    type: File[]
   #    outputSource: run-algs-on-files/cell-cor-file
   # mat-dist-file:
   #    type: File[]
   #    outputSource: run-algs-on-files/mat-dist-file
   # pat-cor-file:
   #    type: File[]
   #    outputSource: run-algs-on-files/pat-cor-file
   # mrna-deconv-file:
   #    type: File[]
   #    outputSource: run-algs-on-files/mrna-deconv-file
   # prot-deconv-file:
   #    type: File[]
   #    outputSource: run-algs-on-files/prot-deconv-file
    

steps:
   run-algs-on-files:
      run: 02-local-compare-across-alg.cwl
      scatter: [mrna-file,prot-file,cancerType]
      scatterMethod: dotproduct
      in:
        signatures: signatures
        mrna-algorithms: mrna-algorithms
        prot-algorithms: prot-algorithms
        mrna-file: mrna-files #scattered
        prot-file: prot-files #scattered
        cancerType: cancerTypes #scattered
        tissueType: #tissueTypes
            valueFrom: "tumor"
      out:
        [pat-cor-file,cell-cor-file,mat-dist-file, mrna-deconv-file, prot-deconv-file]
   plot-sample-cors:
      run: 04-plot-figs.cwl
      in:
        metricType:
            valueFrom: "sample"
        files:
            source: run-algs-on-files/pat-cor-file
      out:
        [table,fig]
   plot-celltype-cors:
      run: 04-plot-figs.cwl
      in:
        metricType:
            valueFrom: "cellType"
        files:
            source: run-algs-on-files/cell-cor-file
      out:
        [table,fig]
   plot-distances:
      run: 04-plot-figs.cwl
      in:
         metric:
            valueFrom: "distance"
         metricType:
            valueFrom: "js"
         files:
            source: run-algs-on-files/mat-dist-file
      out:
        [table,fig]
      
