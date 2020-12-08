#!/usr/bin/env cwltool

label: run-mcpcounter-on-mrna-tool
id: run-mcpcounter-on-mrna-tool
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
  # output:
  #   type: string
  #   inputBinding:
  #     position: 2

outputs:
  deconvoluted:
    type: File
    outputBinding:
      glob: "deconvoluted.tsv"#


