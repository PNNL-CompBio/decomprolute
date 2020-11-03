#!/usr/bin/env cwl-runner

label: mrna-data-cwl-tool
id:  mrna-data-cwl-tool
cwlVersion: v1.0
class: CommandLineTool
baseCommand: mRNADataSetsCLI.py

requirements:
    - class: DockerRequirement
      dockerPull: sgosline/mrna-dat

inputs:
    cancerType:
        type: string
        inputBinding:
            position: 1
            prefix: --cancerType

outputs:
    matrix:
        type: File
        outputBinding:
            glob: "file.tsv"
