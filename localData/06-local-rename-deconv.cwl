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
   cancerType:
      type: string
   algorithms:
      type: string[]
   prot-file:
      type: File
   signatures:
      type: string[]
      
outputs:
   deconv-file:
      type: File[]
      outputSource: run-deconv/deconvoluted

steps:
   rename-prot-file:
      run: 02a-rename-files-by-tissue-tumor-data.cwl
      in:
        fileName: prot-file
        tissueType:
          valueFrom: 'tumor'
        cancerType: cancerType
        dataType:
          valueFrom: 'prot'
      out:
        [outFile]
   get-sigs:
      run: ../signature_matrices/get-signature-matrix.cwl
      scatter: sigMatrixName
      in:
        sigMatrixName: signatures
      out:
        [sigMatrix]
   run-deconv:
      run:  ../tumorDeconvAlgs/run-deconv.cwl
      scatter: [signature,alg]
      scatterMethod: flat_crossproduct
      in:
        signature: get-sigs/sigMatrix
        alg: algorithms
        matrix: rename-prot-file/outFile
      out:
        [deconvoluted]
