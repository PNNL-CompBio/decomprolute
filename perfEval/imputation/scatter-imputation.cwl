#!/usr/bin/env cwltool
class: Workflow
label: scatter-imputation
id: scatter-imputation
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
   signatures:
      type: File[]
      
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
   prot-files-imputed:
      type: File[]
      outputSource: run-all-algs-by-sig/prot-file-imputed
   prot-files:
      type: File[]
      outputSource: run-all-algs-by-sig/prot-file

steps:
   run-all-algs-by-sig:
      run: imputed-vs-unimputed.cwl
      scatter: [signature,prot-alg,cancerType,tissueType]
      scatterMethod: flat_crossproduct
      in:
        signature: signatures
        prot-alg: prot-algorithms
        cancerType: cancerTypes
        tissueType: tissueTypes
      out:
        [pat-cor-file,cell-cor-file,prot-file,prot-file-imputed]
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
