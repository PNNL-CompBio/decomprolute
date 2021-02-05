#!/usr/bin/env cwl-runner

# command: Rscript github_code.R ${list_gene_file} ${data_file} ${n.iter} ${burn.in}

label: rep-bulk
id:  rep-bulk
cwlVersion: v1.0
class: CommandLineTool
baseCommand: Rscript


arguments:
  - /bin/github_code.R


requirements:
  - class: DockerRequirement
    dockerPull: tumordeconv/rep-bulk


inputs:
  list_gene_file:
    type: File
    inputBinding:
      position: 1
  data_file:
    type: File
    inputBinding:
      position: 2
  n_iter:
    type: string
    inputBinding:
      position: 3
  burn_in:
    type: string
    inputBinding:
      position: 4

outputs:
    matrix:
        type: File
        outputBinding:
            glob: "output_rep_bulk.tsv"
