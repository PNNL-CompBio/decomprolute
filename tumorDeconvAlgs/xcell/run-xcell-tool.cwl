#!/usr/bin/env cwltool

label: run-xcell-on-mrna
id: run-xcell-on-mrna
cwlVersion: v1.0
class: CommandLineTool
baseCommand: Rscript

arguments:
  - --vanilla
  - /bin/xcell.r

requirements:
   - class: DockerRequirement
     dockerPull: lifeworks/xcell

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
       glob: "deconvoluted.tsv" #$(inputs.output) 
