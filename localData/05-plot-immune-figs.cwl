#!/usr/bin/env cwltool
class: Workflow
label: local-immune
id: local-immune
cwlVersion: v1.2

requirements:
   - class: SubworkflowFeatureRequirement
   - class: MultipleInputFeatureRequirement
   - class: ScatterFeatureRequirement
   - class: StepInputExpressionRequirement
   - class: InlineJavascriptRequirement

inputs:
   cancerTypes:
      type: string[]
   algorithms:
      type: string[]
   prot-files:
      type: File[]
   signatures:
      type: string[]
      
outputs:
 fig:
     type: File[]
     outputSource: plot-imm/fig
 table:
    type: File[]
    outputSource: plot-imm/table
steps:
   run-algs-on-files:
     run: 06-local-rename-deconv.cwl
     scatter: [prot-file,cancerType]
     scatterMethod: dotproduct
     in:
        prot-file: prot-files
        algorithms: algorithms
        cancerType: cancerTypes
        signatures: signatures
     out:
        [deconv-file]
   arrayBusiness:
    run:
      class: ExpressionTool
      inputs:
        arrayTwoDim:
          type:
            type: array
            items:
              type: array
              items: File
          inputBinding:
            loadContents: true
      outputs:
        array1d:
          type: File[]
      expression: >
        ${
        var newArray= [];
        for (var i = 0; i < inputs.arrayTwoDim.length; i++) {
          for (var k = 0; k < inputs.arrayTwoDim[i].length; k++) {
            newArray.push((inputs.arrayTwoDim[i])[k]);
          }
        }
        return { 'array1d' : newArray }
        }
    in:
        arrayTwoDim: run-algs-on-files/deconv-file
    out: [array1d]
   plot-imm:
    run: ../metrics/imm-subtypes/plot-immune-subtypes.cwl
    in:
      files: arrayBusiness/array1d
    out:
      [table,fig]

