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
   mrna-file:
      type: File
   prot-file:
      type: File
   signatures:
      type: string[]
      
outputs:
   cell-cor-file:
      type: File
      outputSource: get-celltype-cors/table
   mat-dist-file:
      type: File
      outputSource: get-distnace/table

steps:
   run-all-algs-by-sig:
      run: call-deconv-and-cor-on-lists.cwl
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
        [pat-cor-file,cell-cor-file,mat-dist-file]
      
