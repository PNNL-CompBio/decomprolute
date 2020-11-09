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
  data:
    type: File
    inputBinding:
      prefix: -v
      position: 1
  outDir:
     type: Directory
     inputBinding:
       prefix: -v
       position: 2
  username:
    type: string
    inputBinding:
      prefix: --username
      position: 3
  token:
    type: string
    inputBinding:
      prefix: --token
      position: 4
  single_cell:
    type: boolean
    inputBinding:
      prefix: --single_cell
      position: 5
  refsample:
    type: File
    inputBinding:
      prefix: --refsample
      position: 6
  mixture:
    type: File
    inputBinding:
      prefix: --mixture
      position: 7
  fraction:
    type: int
    inputBinding:
      prefix: --fraction
      position: 8
  rmbatchSmode:
    type: string
    inputBinding:
      prefix: --rmbatchSmode
      position: 9
  phenoclasses:
    type: File
    inputBinding:
      prefix: --phenoclasses
      position: 10
  qn:
    type: string
    inputBinding:
      prefix: --QN
      position: 11
  
outputs:
  output:
     type: File
     outputBinding:
       prefix: -v
       position: 2
       
       
