#!/usr/bin/env cwl-runner

# command: Rscript main.R --expressionFile=${expressionFile} --signatureMatrix=${signature_matrix}

label: rep-bulk
id:  rep-bulk
cwlVersion: v1.0
class: CommandLineTool
baseCommand: Rscript


arguments:
  - /bin/main.R


requirements:
  - class: DockerRequirement
    dockerPull: tumordeconv/rep-bulk


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

outputs:
    matrix:
        type: File
        outputBinding:
            glob: "output_rep_bulk.tsv"
    gibbs:
        type: File
        outputBinding:
            glob: "output_rep_bulk_gibbs.Rdata"
