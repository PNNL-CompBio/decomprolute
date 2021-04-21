label: map-sig-tool
id: map-sig-tool
cwlVersion: v1.2
class: CommandLineTool
baseCommand: Rscript

arguments:
   - /bin/mapSimDataMatrices.R

requirements:
   - class: DockerRequirement
     dockerPull: tumodeconv/sim-data


inputs:
  deconv-matrix:
     type: File
     inputBinding:
        position: 1
  sig-matrix:
     type: File
     inputBinding:
        position: 2
  cell-matrix:
     type: File
     inputBinding:
        position: 3
