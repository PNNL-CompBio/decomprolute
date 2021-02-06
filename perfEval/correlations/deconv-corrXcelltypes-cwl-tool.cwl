#!/usr/bin/env cwltool

label: deconv-corrXcelltypes-cwl-tool
id:  deconv-corrXcelltypes-cwl-tool
cwlVersion: v1.0
class: CommandLineTool
baseCommand: python

arguments:
  - /bin/correlationXcelltypes.py

requirements:
  - class: DockerRequirement
    dockerPull: tumordeconv/correlation
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
  mrnaAlg:
    type: string
  protAlg:
    type: string
  cancerType:
    type: string
  spearOrPears:
    type: string
    inputBinding:
      prefix: --spearOrPears
    default: "spearman"
  signature:
    type: File

outputs:
  corr:
    type: File
    outputBinding:
      glob: "corrXcelltypes.tsv" #$(inputs.output)
      outputEval: |
        ${
          var mat = inputs.signature.nameroot
          var name = inputs.cancerType + '-' + inputs.mrnaAlg + '-to-' + inputs.protAlg +'-'+ mat + '-cellTypecorr.tsv'
          self[0].basename = name;
          return self[0]
         }
