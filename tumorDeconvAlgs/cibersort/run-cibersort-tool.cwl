#!/usr/bin/env cwltool

label: run-cibersort-tool
id: run-cibersort-tool
cwlVersion: v1.0
class: CommandLineTool
baseCommand: Rscript

arguments:
  - --vanilla
  - /bin/cibersort.r

requirements:
   - class: DockerRequirement
     dockerPull: lifeworks/cibersort

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
