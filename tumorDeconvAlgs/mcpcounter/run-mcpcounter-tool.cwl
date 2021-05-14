#!/usr/bin/env cwltool

label: run-mcpcounter-tool
id: run-mcpcounter-tool
cwlVersion: v1.2
class: CommandLineTool
baseCommand: Rscript

arguments:
  - --vanilla
  - /bin/mcpcounter.r

requirements:
  - class: DockerRequirement
    dockerPull: tumordeconv/mcpcounter
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
      glob: "deconvoluted.tsv"#
      outputEval: |
         ${
           var mat = inputs.signature.nameroot
           var cancer = inputs.expression.nameroot
           var name = cancer + '-mcpcounter-'+ mat + '.tsv'
           self[0].basename = name;
           return self[0]
           }



