#!/usr/bin/env cwl-runner

label: prot-data-cwl-tool
id:  prot-data-cwl-tool
cwlVersion: v1.0
class: CommandLineTool
baseCommand: python

arguments:
     - /bin/protDataSetsCLI.py

requirements:
    - class: DockerRequirement
      dockerPull: tumordeconv/prot-data

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
                  var name = inputs.cancerType + '-' + inputs.sampleType + '-' 'prot.tsv'
                  self[0].basename = name;
                  return self[0]
                }
