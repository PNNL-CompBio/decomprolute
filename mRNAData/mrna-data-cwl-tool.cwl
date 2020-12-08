#!/usr/bin/env cwltool

label: mrna-data-cwl-tool
id:  mrna-data-cwl-tool
cwlVersion: v1.0
class: CommandLineTool
baseCommand: python

arguments:
     - /bin/mRNADataSetsCLI.py

requirements:
    - class: DockerRequirement
      dockerPull: lifeworks/deconv-mrna

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
