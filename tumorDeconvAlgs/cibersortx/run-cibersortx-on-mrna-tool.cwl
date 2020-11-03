label: run-cibersortx-on-mrna
id: run-cibersortx-on-mrna
cwlVersion: v1.0
class: CommandLineTool
baseCommand: 

requirements:
  class: DockerRequirement
  - dockerPull: cibersortx/gep
  - dockerPull: cibersortx/hires
  - dockerPull: cibersortx/fractions

arguments:
  - username:
      type: string
      prefix: --username
  - token:
      type: string
      prefix: --token
  - single_cell:
      type: boolean
      prefix: --single_cell

inputs:
  data:
    type: File
    position: 1
    inputBinding:
      prefix: -v
    
outputs:
  outDir:
     type: Directory
     position: 2
     outputBinding:
       prefix: -v
