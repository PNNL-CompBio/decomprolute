#!/usr/bin/env cwl-runner

label: sim-data-cwl-tool
id:  sim-data-cwl-tool
cwlVersion: v1.0
class: CommandLineTool
baseCommand: Rscript

arguments:
     - /bin/getSimDataMatrices.R


requirements:
    - class: DockerRequirement
      dockerPull: tumordeconv/sim-data

inputs:
    simType:
        type: string
        inputBinding:
            position: 1
    repNumber:
        type: string?
        inputBinding:
            position: 2
       
outputs:
    matrix:
        type: File
        outputBinding:
            glob: "*matrix.tsv"
    cellType:
        type: File
        outputBinding:
            glob: "*Preds.tsv"
