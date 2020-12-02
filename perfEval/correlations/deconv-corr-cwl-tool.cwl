#!/usr/bin/env cwl-runner

label: deconv-corr-cwl-tool
id:  deconv-corr-cwl-tool
cwlVersion: v1.0
class: CommandLineTool
baseCommand: python

arguments:
  - /bin/correlation.py

requirements:
  - class: DockerRequirement
    dockerPull: lifeworks/deconv-corr


inputs:
  transcriptomics:
    type: string
    inputBinding:
      prefix: --transcriptomics
  proteomics:
    type: string
    inputBinding:
      prefix: --proteomics
  output:
    type: string
    inputBinding:
      prefix: --output

outputs:
  corr:
    type: File
    outputBinding:
      glob: $(inputs.output)
