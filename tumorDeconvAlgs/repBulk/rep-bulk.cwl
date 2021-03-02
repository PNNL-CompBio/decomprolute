#!/usr/bin/env cwl-runner

# command: Rscript main.R --expressionFile=${expressionFile} --signatureMatrix=${signature_matrix}

label: rep-bulk
id:  rep-bulk
cwlVersion: v1.2
class: CommandLineTool
baseCommand: Rscript

arguments:
  - /bin/main.R

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
  # dataType:
  #   type: string
  # cancerType:
  #   type: string

outputs:
  deconvoluted:
    type: File
    outputBinding:
      glob: "output_rep_bulk.tsv"
      outputEval: |
        ${
          var mat = inputs.signatureMatrix.nameroot
          var cancer = inputs.expression.nameroot
          var name = cancer + '-repbulk-'+ mat + '.tsv'
          self[0].basename = name;
          return self[0]
          }
            
#    gibbs:
#        type: File
#        outputBinding:
#            glob: "output_rep_bulk_gibbs.Rdata"
