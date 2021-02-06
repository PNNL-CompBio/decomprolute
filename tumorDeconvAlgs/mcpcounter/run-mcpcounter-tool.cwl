#!/usr/bin/env cwltool

label: run-mcpcounter-tool
id: run-mcpcounter-tool
cwlVersion: v1.0
class: CommandLineTool
baseCommand: Rscript

arguments:
  - --vanilla
  - /bin/mcpcounter.r

requirements:
  - class: DockerRequirement
    dockerPull: lifeworks/mcpcounter

inputs:
  expression:
    type: File
    inputBinding:
      position: 1
  signature:
    type: File
    inputBinding:
      position: 2

outputs:
  deconvoluted:
    type: File
    outputBinding:
      glob: "deconvoluted.tsv"#


