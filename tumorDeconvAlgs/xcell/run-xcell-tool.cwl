#!/usr/bin/env cwltool

label: run-xcell-tool
id: run-xcell-tool
cwlVersion: v1.2
class: CommandLineTool
baseCommand: Rscript

arguments:
  - --vanilla
  - /bin/xcell.r

requirements:
   - class: DockerRequirement
     dockerPull: tumordeconv/xcell
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
  # dataType:
  #   type: string
  # cancerType:
  #   type: string

outputs:
  deconvoluted:
     type: File
     outputBinding:
       glob: "deconvoluted.tsv" #$(inputs.output)
       outputEval: |
         ${
           var mat = inputs.signature.nameroot
           var cancer = inputs.expression.nameroot
           var name = cancer + '-xcell-'+ mat + '.tsv'
           self[0].basename = name;
           return self[0]
           }
