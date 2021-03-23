#!/usr/bin/env cwltool

label: deconv-comparison-tool
id:  deconv-comparison-tool
cwlVersion: v1.0
class: CommandLineTool
baseCommand: python

arguments:
  - /bin/comparison.py

requirements:
  - class: DockerRequirement
    dockerPull: tumordeconv/comparison
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement

inputs:
  matrixA:
    type: File
    inputBinding:
      prefix: --matrixA
  matrixB:
    type: File
    inputBinding:
      prefix: --matrixB
  method:
    type: string
    inputBinding:
      prefix: --method
    default: "ks"
  cancerType:
    type: string
  aAlg:
    type: string
  bAlg:
    type: string
  signature:
    type: File
  sampleType:
    type: string

outputs:
  dist:
    type: File
    outputBinding:
      glob: "dist.tsv" 
      outputEval: |
        ${
          var mat = inputs.signature.nameroot
          var name = inputs.sampleType + '-' + inputs.cancerType + '-' + inputs.aAlg + '-to-' + inputs.bAlg +'-'+ mat + '-dist.tsv'
          self[0].basename = name;
          return self[0]
         }
