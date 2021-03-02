#!/usr/bin/env cwl-runner

label: mrna-data-cwl-tool
id:  mrna-data-cwl-tool
cwlVersion: v1.0
class: CommandLineTool
baseCommand: python

arguments:
     - /bin/mRNADataSetsCLI.py

requirements:
    - class: DockerRequirement
      dockerPull: tumordeconv/mrna-data
    - class: InlineJavascriptRequirement

inputs:
    cancerType:
        type: string
        inputBinding:
            position: 1
            prefix: --cancerType

    sampleType:
        type: string?
        default: "all"
        inputBinding:
            position: 2
            prefix: --sampleType

outputs:
    matrix:
        type: File
        outputBinding:
            glob: "file.tsv"
            outputEval: |
                ${
                  var name = inputs.cancerType + '-' + inputs.sampleType + '-' + 'mrna.tsv'
                  self[0].basename = name;
                  return self[0]
                  }
