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
  dataType:
     type: string?
  cancerType:
     type: string?


outputs:
  deconvoluted:
    type: File
    outputBinding:
       glob: "output_bayes_de_bulk.tsv"
       outputEval: |
          ${
            var mat = inputs.signatureMatrix.nameroot
            var name = inputs.cancerType + '-repbulk-'+ mat + '-'+inputs.type+'-deconv.tsv'
            self[0].basename = name;
            return self[0]
           }
            
#    gibbs:
#        type: File
#        outputBinding:
#            glob: "output_rep_bulk_gibbs.Rdata"
