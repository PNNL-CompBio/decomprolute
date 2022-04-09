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
   dist-files:
      type: File[]
      outputSource: run-all-algs-by-sig/mat-dist-file
   dist-fig:
      type: File[]
      outputSource: get-distances/fig
   dist-tab:
      type: File
      outputSource: get-distances/table
    

steps:
   run-algs-on-files:
   run-all-algs-by-sig:
      run: call-deconv-and-cor-on-lists.cwl
      scatter: [signature,mrna-alg,prot-alg,cancerType,tissueType]
      scatterMethod: flat_crossproduct
      in:
        signature: signatures
        mrna-alg: mrna-algorithms
        prot-alg: prot-algorithms
        cancerType: cancerTypes
        tissueType: tissueTypes
      out:
        [pat-cor-file,cell-cor-file,prot-file,mrna-file,mat-dist-file]
   get-celltype-cors:
      run: ../figures/plot-figs.cwl
      in:
        metricType:
            valueFrom: "cellType"
        files:
            source: run-all-algs-by-sig/cell-cor-file
      out:
        [table,fig]
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
      
