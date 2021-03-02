#!/usr/bin/env cwl-runner

# command: Rscript DreamAI.R ${INPUT_FILE} ${use_missForest}

label: imputation-tool
id:  imputation-tool
cwlVersion: v1.0
class: CommandLineTool
baseCommand: Rscript


arguments:
  - /bin/DreamAI.R


requirements:
  - class: DockerRequirement
    dockerPull: cptacdream/sub1
  - class: InlineJavascriptRequirement


inputs:
  input_f:
    type: File
    inputBinding:
      position: 1
  use_missForest:
    type: string?
    default: "false"
    inputBinding:
      position: 2

outputs:
    matrix:
        type: File
        outputBinding:
            glob: "imputed_file.tsv"
            outputEval: |
                ${
                  var cancer = inputs.input_f.nameroot
                  var name = cancer + '-imputed.tsv'
                  self[0].basename = name;
                  return self[0]
                }
