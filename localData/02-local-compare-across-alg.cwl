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
   rename-mrna-file:
      run: 02a-rename-files-by-tissue-tumor-data.cwl
      in:
        fileName: mrna-file
        tissueType: tissueType
        cancerType: cancerType
        dataType:
          valueFrom: 'rna'
      out:
        [outFile]
   rename-prot-file:
      run: 02a-rename-files-by-tissue-tumor-data.cwl
      in:
        fileName: prot-file
        tissueType: tissueType
        cancerType: cancerType
        dataType:
          valueFrom: 'prot'
      out:
        [outFile]
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
        mrna-file: rename-mrna-file/outFile
        prot-file: rename-prot-file/outFile
      out:
        [pat-cor-file,cell-cor-file,mat-dist-file, mrna-deconv-file, prot-deconv-file]
      
