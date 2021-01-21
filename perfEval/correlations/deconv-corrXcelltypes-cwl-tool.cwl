#!/usr/bin/env cwltool

label: deconv-corrXcelltypes-cwl-tool
id:  deconv-corrXcelltypes-cwl-tool
cwlVersion: v1.0
class: CommandLineTool
baseCommand: python

arguments:
  - /bin/correlationXcelltypes.py

requirements:
  - class: DockerRequirement
    dockerPull: lifeworks/deconv-corr


inputs:
  transcriptomics:
    type: File
    inputBinding:
      prefix: --transcriptomics
  proteomics:
    type: File
    inputBinding:
      prefix: --proteomics
  # output:
  #   type: string
  #   inputBinding:
  #     prefix: --output

outputs:
  corr:
    type: File
    outputBinding:
      glob: "corrXcelltypes.tsv" #$(inputs.output)
