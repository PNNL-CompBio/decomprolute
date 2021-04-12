#!/usr/bin/env cwl-runner

# command: Rscript main.R --expressionFile=${expressionFile} --signatureMatrix=${signature_matrix}

label: rep-bulk
id:  rep-bulk
cwlVersion: v1.2
class: CommandLineTool
baseCommand: Rscript

arguments:
  - /bin/main_docker.R

requirements:
  - class: DockerRequirement
    dockerPull: tumordeconv/rep-bulk
  - class: InlineJavascriptRequirement
  
inputs:
  expressionFile:
    type: File
    inputBinding:
      position: 1
      prefix: --expressionFile
  signatureMatrix:
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
      glob: "output_bayes_de_bulk.tsv"
      outputEval: |
        ${
          var mat = inputs.signatureMatrix.nameroot
          var cancer = inputs.expressionFile.nameroot
          var name = cancer + '-repbulk-'+ mat + '.tsv'
          self[0].basename = name;
          return self[0]
          }
