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
  type:
    type: string
  cancerType:
    type: string

outputs:
  deconvoluted:
    type: File
    outputBinding:
      glob: "deconvoluted.tsv"#
      outputEval: |
         ${
           var mat = inputs.signature.nameroot
           var name = inputs.cancerType + '-mcpcounter-'+ mat + '-'+inputs.type+'-deconv.tsv'
           self[0].basename = name;
           return self[0]
           }


