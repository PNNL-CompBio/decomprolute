#!/usr/bin/env cwltool

label: deconv-corr-cwl-tool
id:  deconv-corr-cwl-tool
cwlVersion: v1.0
class: CommandLineTool
baseCommand: python

arguments:
  - /bin/correlation.py

requirements:
  - class: DockerRequirement
    dockerPull: tumordeconv/correlation
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement

inputs:
  transcriptomics:
    type: File
    inputBinding:
      prefix: --transcriptomics
  proteomics:
    type: File
    inputBinding:
      prefix: --proteomics
  spearmanOrPearson:
    type: string
    inputBinding:
      prefix: --spearOrPears
    default: "pearson"
  cancerType:
    type: string
  algorithm:
    type: string
  signature:
    type: File
  # output:
  #   type: string
  #   inputBinding:
  #     prefix: --output

outputs:
  corr:
    type: File
    outputBinding:
      glob: "corr.tsv" 
      outputEval: |
        ${
          var mat = inputs.signature.nameroot
          var name = inputs.cancerType + '-' + inputs.algorithm + '-' + mat + '-corr.tsv'
          self[0].basename = name;
          return self[0]
         }
