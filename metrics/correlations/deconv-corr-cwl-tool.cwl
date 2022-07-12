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
  spearOrPears:
    type: string
    inputBinding:
      prefix: --spearOrPears
    default: "spearman"
  cancerType:
    type: string
  mrnaAlg:
    type: string
  protAlg:
    type: string
  signature:
    type: string
  sampleType:
    type: string

outputs:
  corr:
    type: File
    outputBinding:
      glob: "corr.tsv" 
      outputEval: |
        ${
          var mat = inputs.signature
          var name = inputs.sampleType + '-' + inputs.cancerType + '-' + inputs.mrnaAlg + '-to-' + inputs.protAlg +'-'+ mat + '-corr.tsv'
          self[0].basename = name;
          return self[0]
         }
