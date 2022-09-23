#!/usr/bin/env cwl-runner

# command: Rscript main_docker.R --expressionFile=${expressionFile} --signatureMatrix=${signature_matrix}

label: rep-bulk
id:  rep-bulk
cwlVersion: v1.2
class: CommandLineTool
baseCommand: Rscript

arguments:
  - /bin/main_docker.R

requirements:
  - class: DockerRequirement
    dockerPull: tumordeconv/in-progress
  - class: InlineJavascriptRequirement
  
inputs:
  expression:
    type: File
    inputBinding:
      position: 1
      prefix: --expressionFile
  signature:
    type: File
    inputBinding:
      position: 2
      prefix: --signatureMatrix
  rowMeansImputation:
    type: string?
    inputBinding:
      position: 3
      prefix: --rowMeansImputation

outputs:
  deconvoluted:
    type: File
    outputBinding:
      glob: "deconvoluted.tsv"
      outputEval: |
        ${
          var mat = inputs.signature.nameroot
          var cancer = inputs.expression.nameroot
          var name = cancer + '-bayesdebulk-'+ mat + '.tsv'
          self[0].basename = name;
          return self[0]
          }
