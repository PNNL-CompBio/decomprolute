label: run-xcell-on-mrna
id: run-xcell-on-mrna
cwlVersion: v1.0
class: CommandLineTool
baseCommand: xcell

requirements:
   - class: DockerRequirement
     dockerPull: vacation/xcell

inputs:
  rnaseq:
   type: string
   inputBinding:
      position: 1
      prefix: --rnaseq
  scale:
    type: string
    inputBinding:
      position: 2
      prefix: --scale
  alpha: 
    type: int
    inputBinding:
      position: 3
      prefix: --alpha
  nperm:
    type: int
    inputBinding:
      position: 4
      prefix: --nperm
  parallel.sz:
    type: int
    inputBinding:
      position: 5
      prefix: --parallel_sz
  verbose:
    type: boolean
    inputBinding:
      position: 6
      prefix: --verbose
  tempdir:
    type: string
    inputBinding:
      position: 7
      prefix: --tempdir
  beta_pval:
    type: string
    inputBinding:
      position: 8
      prefix: --beta_pval
  perm_pval:
    type: string
    inputBinding:
      position: 9
      prefix: --perm_pval
  output:
    type: string
    inputBinding:
      position: 10
      prefix: --output
  tsv_in:
    type: boolean
    inputBinding:
      prefix: --tsv_in
  tsv_out:
    type: boolean
    inputBinding:
      prefix: --tsv_out
  matrix:
    type: boolean
    inputBinding:
      prefix: --matrix

outputs:
  pathways:
     type: File
     outputBinding:
       glob: $(inputs.output) #"deconvoluted.tsv"
