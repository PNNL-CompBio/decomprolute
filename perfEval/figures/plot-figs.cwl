#!/usr/bin/env cwltool

class: CommandLineTool
label: plot-figs
id: plot-figs
cwlVersion: v1.2
baseCommand: Rscript

arguments:
   - /bin/combine_results.R

requirements:
   - class: DockerRequirement
     dockerPull: tumordeconv/figures
   - class: MultipleInputFeatureRequirement

inputs:
   sampOrCell:
     type: string
     inputBinding:
       position: 1
   files:
     type:  File[]
     inputBinding:
        position: 2

outputs:
   table:
     type: File
     outputBinding:
       glob: "*.tsv"
   fig:
     type: File
     outputBinding:
        glob: "*.pdf"
    