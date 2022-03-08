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
  corFiles:
    type: File[]
    inputBinding:
       position: 1

stdout: 
   message.txt

outputs:
  value:
    type: string
    outputBinding:
      glob: message.txt
      loadContents: true
      outputEval: $(self[0].contents)
