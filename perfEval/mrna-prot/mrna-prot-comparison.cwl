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
   mrna-files:
      type: File[]
      outputSource: run-all-algs-by-sig/mrna-file
   prot-files:
      type: File[]
      outputSource: run-all-algs-by-sig/prot-file
   dist-files:
      type: File[]
      outputSource: run-all-algs-by-sig/mat-dist-file

steps:
   run-all-algs-by-sig:
      run: call-deconv-and-cor.cwl
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
