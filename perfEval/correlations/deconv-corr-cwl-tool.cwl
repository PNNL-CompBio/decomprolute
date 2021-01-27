#!/usr/bin/env cwltool

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
    type: File
    inputBinding:
      prefix: --transcriptomics
  proteomics:
    type: File
    inputBinding:
      prefix: --proteomics
  spearmanOrPearson:
    type: string
    inputBinding:
      prefix: --spearOrPears
  # output:
  #   type: string
  #   inputBinding:
  #     prefix: --output

outputs:
  corr:
    type: File
    outputBinding:
      glob: "corr.tsv" #$(inputs.output)
