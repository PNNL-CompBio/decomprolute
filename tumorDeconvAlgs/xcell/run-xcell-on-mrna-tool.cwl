label: run-xcell-on-mrna
id: run-xcell-on-mrna
cwlVersion: v1.0
class: CommandLineTool
baseCommand: Rscript

arguments:
  - --vanilla
  - /root/xcell.r

requirements:
   - class: DockerRequirement
     dockerPull: lifeworks/xcell

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
       glob: $(inputs.output) #"deconvoluted.tsv"
