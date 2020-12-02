label: run-cibersortx-on-mrna
id: run-cibersortx-on-mrna
cwlVersion: v1.0
class: CommandLineTool
baseCommand: 

hints:
  DockerRequirement:
    dockerPull: cibersortx/fractions
    # dockerPull: cibersortx/gep
    # dockerPull: cibersortx/hires

inputs:
  # data:
  #   type: string
  #   inputBinding:
  #     prefix: -v
  #     position: 1
  # outDir:
  #    type: string
  #    inputBinding:
  #      prefix: -v
  #      position: 2
  username:
    type: string
    inputBinding:
      prefix: --username
  token:
    type: string
    inputBinding:
      prefix: --token
  mixture:
    type: File
    inputBinding:
      prefix: --mixture
  sigmatrix:
    type: File
    inputBinding:
      prefix: --sigmatrix
  perm:
    type: int
    inputBinding:
      prefix: --perm
  samplelabel:
    type: string
    inputBinding:
      prefix: --label
  rmbatchSmode:
    type: string
    inputBinding:
      prefix: --rmbatchSmode
  rmbatchBmode:
    type: string
    inputBinding:
      prefix: --rmbatchBmode
  sourceGEPs:
    type: File
    inputBinding:
      prefix: --sourceGEPs
  qn:
    type: string
    inputBinding:
      prefix: --QN
  absolute:
    type: string
    inputBinding:
      prefix: --absolute
  abs_method:
    type: string
    inputBinding:
      prefix: --abs_method
  verbose:
    type: string
    inputBinding:
      prefix: --verbose
  outdir:
    type: Directory
    inputBinding:
      prefix: --outdir
  refsample:
    type: File
    inputBinding:
      prefix: --refsample
  phenoclasses:
    type: File
    inputBinding:
      prefix: --phenoclasses
  single_cell:
    type: boolean
    inputBinding:
      prefix: --single_cell
  G.min:
    type: int
    inputBinding:
      prefix: --G.min
  G.max:
    type: int
    inputBinding:
      prefix: --G.max
  q.value:
    type: int
    inputBinding:
      prefix: --q.value
  filter:
    type: string
    inputBinding:
      prefix: --filter
  k.max:
    type: int
    inputBinding:
      prefix: --k.max
  remake:
    type: string
    inputBinding:
      prefix: --remake
  replicates:
    type: int
    inputBinding:
      prefix: --replicates
  sampling:
    type: float
    inputBinding:
      prefix: sampling
  fraction:
    type: float
    inputBinding:
      prefix: --fraction

outputs:
  output:
     type: File
     outputBinding:
       glob: "*.txt"
       
       
