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
   figures:

steps:
    run-all-algs-by-sig:
       run: run-algs-with-sig-alg-cancer.cwl
       scatter: [signature,prot-alg,mrna-alg,cancerType]
       scaterMethod: flat_crossproduct
       in:
         signature: signatures
         prot-alg: prot-algorithms
         mrna-alg: mrna-algorithms
         cancerType: cancerTypes
       out:
         [cell-matrix,sample-matrix]
    get-patient-cors:
        run: figures/plot-figs.cwl
        in:
          type: cellType
          files: [run-all-algs-by-sig/cell-matrix]
        out:
          [table,fig]
    get-celltype-cors:
        run: figures/plot-figs.cwl
        in:
          sampOrCell: sample
          files:[run-all-algs-by-sig/sample-matrix]
        out:
          [table,fig]
