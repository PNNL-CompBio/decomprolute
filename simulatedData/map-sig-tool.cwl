label: map-sig-tool
id: map-sig-tool
cwlVersion: v1.2
class: CommandLineTool
baseCommand: Rscript

arguments:
   - /bin/mapSimDataMatrices.R

requirements:
   - class: DockerRequirement
     dockerPull: tumordeconv/sim-data


inputs:
  deconv-matrix:
     type: File
     inputBinding:
        position: 1
  sig-matrix:
     type: File
     inputBinding:
        position: 2
  deconv-type:
     type: string
     inputBinding:
        position: 3
  cell-matrix:
     type: File
     inputBinding:
        position: 4

outputs:
  updated-deconv:
     type: File
     outputBinding:
        glob: "*Deconv.tsv"
  updated-cell-matrix:
     type: File
     outputBinding:
        glob: "*Cells.tsv"
