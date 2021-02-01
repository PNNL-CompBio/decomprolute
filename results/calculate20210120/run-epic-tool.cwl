#!/usr/bin/env cwltool

label: run-epic-tool
id: run-epic-tool
cwlVersion: v1.0
class: CommandLineTool
baseCommand: Rscript

arguments:
  - --vanilla
  - /bin/epic.r

requirements:
   - class: DockerRequirement
     dockerPull: lifeworks/epic

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
       glob: "deconvoluted.tsv" #$(inputs.output) 