label: run-xcell-on-mrna
id: run-xcell-on-mrna
cwlVersion: v1.0
class: CommandLineTool
baseCommand: Rscript

requirements:
   - class: DockerRequirement
     dockerPull: vacat ion/xcell

arguments:
  - xcell.r

inputs:
  rnaseq:
   type: string
   inputBinding:
      position: 1
  scale:
    type: string
    inputBinding:
      position: 2
  alpha: 
    type: int
    inputBinding:
      position: 3
  nperm:
    type: int
    inputBinding:
      position: 4
  parallel.sz:
    type: int
    inputBinding:
      position: 5
  verbose:
    type: string
    inputBinding:
      position: 6
  tempdir:
    type: string
    inputBinding:
      position: 7
  beta_pval:
    type: string
    inputBinding:
      position: 8
  perm_pval:
    type: string
    inputBinding:
      position: 9
    
outputs:
  pathways:
     type: File
     outputBinding:
        glob: "*/pathways.csv"
