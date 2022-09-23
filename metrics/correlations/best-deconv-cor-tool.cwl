#!/usr/bin/env cwltool

label: best-deconv-cor-tool
id:  best-deconv-cor-tool
cwlVersion: v1.0
class: CommandLineTool
baseCommand: python

arguments:
  - /bin/getBestCor.py

requirements:
  - class: DockerRequirement
    dockerPull: tumordeconv/correlation
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement

inputs:
  alg_or_mat:
    type: string
    inputBinding:
       position: 1
  corFiles:
    type: File[]
    inputBinding:
       position: 2

stdout: 
   message

outputs:
  value:
    type: string
    outputBinding:
      glob: message
      loadContents: true
      outputEval: $(self[0].contents)
