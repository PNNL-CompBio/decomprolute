#~/usr/bin/env cwltool
class: CommandLineTool
label: rename-files
id: rename-files
cwlVersion: v1.2
baseCommand: cp

requirements:
  - class: InlineJavascriptRequirement

inputs:
  fileName:
     type: File
  tissueType:
     type: string
  cancerType:
     type: string
  dataType:
     type: string

outputs:
  outFile:
    type: File
    outputBinding:
       glob: "tmp.tsv"
       outputEval: |
           ${
              self[0].basename = ''+inputs.cancerType+'-'+inputs.tissueType+'-'+inputs.dataType+'-raw.tsv';
              return self[0]
            }
  
arguments: [$(inputs.fileName), "tmp.tsv"]

