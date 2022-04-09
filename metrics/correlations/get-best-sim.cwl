class: CommandLineTool
label: best-sim
id: best-sim
cwlVersion: v1.2
baseCommand: python3

arguments:
   - /bin/getBestSim.py
requirements:
   - class: DockerRequirement
     dockerPull: tumordeconv/correlation
   - class: InlineJavascriptRequirement
inputs:
  output:
    type: string
    inputBinding:
      position: 1
  file:
    type: File
    inputBinding:
     position: 2

stdout:
  message
  
outputs:
  value:
    type: string
    outputBinding:
       glob: message
       loadContents: true
       outputEval: $(self[0].contents)
    
