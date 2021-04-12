#!/usr/bin/env cwltool

label: run-epic-tool
id: run-epic-tool
cwlVersion: v1.2
class: CommandLineTool
baseCommand: Rscript

arguments:
  - --vanilla
  - /bin/epic.r

requirements:
   - class: DockerRequirement
     dockerPull: tumordeconv/epic
   - class: InlineJavascriptRequirement

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
       outputEval: |
         ${
           var mat = inputs.signature.nameroot
           var cancer = inputs.expression.nameroot
           var name = cancer + '-epic-'+ mat + '.tsv'
           self[0].basename = name;
           return self[0]
           }
