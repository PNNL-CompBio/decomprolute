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

outputs:
  cor:
    type: string
  alg:
    type: string
  matrix:
    type: string
