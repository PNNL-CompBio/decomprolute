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
      run: 02-local-compare-across-alg.cwl
      scatter: [mrna-file,prot-file,cancerType]
      scatterMethod: flat_dotproduct
      in:
        signatures: signatures
        mrna-algorithms: mrna-algorithms
        prot-algorithms: prot-algorithms
        mrna-file: mrna-file #scattered
        prot-file: prot-files #scattered
        cancerType: cancerTypes #scattered
      outputs:
        [cell-cor-file,mat-dist-file]        
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
      
