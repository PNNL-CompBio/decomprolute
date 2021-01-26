#!/usr/bin/env cwltool

class: Workflow
label: scatter-test
id: scatter-test
cwlVersion: v1.2


requirements:
   - class: SubworkflowFeatureRequirement
   - class: MultipleInputFeatureRequirement
   - class: ScatterFeatureRequirement

inputs:
   cancerTypes:
      type: [string]
   prot-algorithms:
      type: [string]
   mrna-algorithms:
      type: [string]
   signatures:
      type: [File]
      
outputs:
   pat-cor-tab:
        type: File
        outputSource: get-patient-cors/table
   pat-fig:
        type: File
        outputSource: get-patient-cors/fig
#   cell-cor-tab:
#        type: File
#        outputSource: get-celltype-cors/table
#   cell-fig:
#        type: File
#        outputSource: get-celltype-cors/fig
steps:
    run-all-algs-by-sig:
       run: call-deconv-by-arg.cwl
       scatter: [signature,prot-alg,cancerType]
       scatterMethod: flat_crossproduct
       in:
         signature: signatures
         prot-alg: prot-algorithms
      #   mrna-alg: mrna-algorithms
         cancerType: cancerTypes
       out:
         [corr]
    get-patient-cors:
        run: figures/plot-figs.cwl
        in:
          sampOrCell:
             valueFrom: "sample"
          files: [run-all-algs-by-sig/corr]
        out:
          [table,fig]
   # get-celltype-cors:
   #     run: figures/plot-figs.cwl
   #     in:
   #       sampOrCell:
   #           valueFrom: "cellType"
   #       files: [run-all-algs-by-sig/sample-matrix]
   #     out:
   #       [table,fig]
