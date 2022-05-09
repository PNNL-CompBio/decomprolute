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
   tissueType:
      type: string
   cancerType:
      type: string
   prot-algorithms:
      type: string[]
   mrna-algorithms:
      type: string[]
   mrna-file:
      type: File
   prot-file:
      type: File
   signatures:
      type: string[]
      
outputs:
   cell-cor-file:
      type: File[]
      outputSource: run-all-algs-by-sig/cell-cor-file
   mat-dist-file:
      type: File[]
      outputSource: run-all-algs-by-sig/mat-dist-file
   pat-cor-file:
      type: File[]
      outputSource: run-all-algs-by-sig/pat-cor-file
   mrna-deconv-file:
      type: File[]
      outputSource: run-all-algs-by-sig/mrna-deconv-file
   prot-deconv-file:
      type: File[]
      outputSource: run-all-algs-by-sig/prot-deconv-file

steps:
   run-all-algs-by-sig:
      run: 03-local-deconv-cor.cwl
      scatter: [signature,mrna-alg,prot-alg]
      scatterMethod: flat_crossproduct
      in:
        signature: signatures
        mrna-alg: mrna-algorithms
        prot-alg: prot-algorithms
        cancerType: cancerType
        tissueType: tissueType
        mrna-file: mrna-file
        prot-file: prot-file
      out:
        [pat-cor-file,cell-cor-file,mat-dist-file, mrna-deconv-file, prot-deconv-file]
      
