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
    

steps:
   run-all-algs-by-sig:
      run: call-deconv-and-cor.cwl
      scatter: [signature,mrna-alg,prot-alg,tissueType,cancerType]
      scatterMethod: flat_crossproduct
      in:
        signature: signatures
        mrna-alg: mrna-algorithms
        prot-alg: prot-algorithms
        cancerType: cancerTypes
        tissueType: tissueTypes
      out:
        [pat-cor-file,cell-cor-file,prot-file,mrna-file]
   get-celltype-cors:
      run: ../figures/plot-figs.cwl
      in:
        metricType:
            valueFrom: "cellType"
        files:
            source: run-all-algs-by-sig/cell-cor-file
      out:
        [table,fig]
#   get-distances:
#      run: ../figures/plot-figs.cwl
#      in:
#         metric:
#            valueFrom: "distance"
#         metricType:
#            valueFrom: "cellType"
#         files:
#            source: run-all-algs-by-sig/mat-dist-file
#      out:
#        [table,fig]
      
