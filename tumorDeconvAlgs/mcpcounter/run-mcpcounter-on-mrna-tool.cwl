label: run-mcpcounter-on-mrna-tool
id: run-mcpcounter-on-mrna-tool
cwlversion: v1.0
class: CommandLineTool
baseCommand: Rscript

arguments:
  - --vanilla
  - /root/mcpcounter.r

requirements:
  - class: DockerRequirement
    dockerPull: lifeworks/mcpcounter

inputs:
  rnaseq:
    type: string
    inputBinding:
      position: 1
  output:
    type: string
    inputBinding:
      position: 2

outputs:
  deconvoluted:
    type: File
    outputBinding:
      glob: $(inputs.output) #"deconvoluted.tsv"#


