#!/usr/bin/env cwltool

class: CommandLineTool
label: get-signature-matrix
id: get-signature-matrix
cwlVersion: v1.2
baseCommand: Rscript

arguments:
  - /getSigMatrices.R

requirements:
  - class: DockerRequirement
    dockerPull: tumordeconv/signature_matrices
  - class: MultipleInputFeatureRequirement

inputs:
  sigMatrixName:
    type: string
    inputBinding:
      position: 1

outputs:
  sigMatrix:
    type: File
    outputBinding:
      glob: "*.txt"
 
