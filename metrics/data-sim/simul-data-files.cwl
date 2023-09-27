#!/usr/bin/env cwltool
class: Workflow
label: simul-data-sampling
id: simul-data-sampling
cwlVersion: v1.2

requirements:
   - class: SubworkflowFeatureRequirement
   - class: MultipleInputFeatureRequirement
   - class: ScatterFeatureRequirement
   - class: StepInputExpressionRequirement
   - class: InlineJavascriptRequirement

inputs:
   num-reps:
      type: int
      default: 1
   samples:
      type: int[]
      default: [20,40,60,80,100]
   mrna-perms:
      type: string[]
      default: ['1','2','3','4','5','6','7','8','9','10','pbmc']
   prot-perms:
      type: string[]
      default: ['1','2','3','4','5']
   prot-algorithms:
      type: string[]
      default:
      - mcpcounter
      - xcell
      - epic
      - cibersort
   rna-sigs: 
      type: string[]
      default: ['LM22','PBMC']
   prot-sigs:
      type: string[]
      default: ['LM7c','LM9']
   simType: 
      type: string

outputs:
   cell-cor-file:
      type: File[]
      outputSource: run-all-algs-by-prot
   deconv:
      type: File[]
      outputSource: run-all-algs-by-prot
   cellPred:
      type: File[]
      outputSource: run-all-algs-by-prot
   deconvoluted:
      type: File[]
      outputSource: run-all-algs-by-prot
   matrix:
      type: File[]
      outputSource: run-all-algs-by-prot


steps:
   run-all-algs-by-mrna:
     run: call-deconv-on-sim.cwl
     when: $(inputs.simType.trim() == 'mrna')
     scatter: [protAlg,permutation,signature,samples]
     scatterMethod: flat_crossproduct
     in:
        protAlg: prot-algorithms
        permutation: mrna-perms
        signature: rna-sigs
        sample: samples
        num-reps: num-reps
        sampleType:
          valueFrom: 'normal'
        dataType:
          valueFrom: 'prot'
        simType: simType
     out:
        [cell-cor-file, deconv, cellPred, deconvoluted, matrix]
   run-all-algs-by-prot:
     run: call-deconv-on-sim.cwl
     when: $(inputs.simType.trim() == 'prot')
     scatter: [protAlg,permutation,signature,samples]
     scatterMethod: flat_crossproduct
     in:
        protAlg: prot-algorithms
        permutation: prot-perms
        sample: samples
        num-reps: num-reps
        signature: prot-sigs
        sampleType:
          valueFrom: 'normal'
        dataType:
          valueFrom: 'prot'
        simType: simType
     out:
        [cell-cor-file,deconv, cellPred, deconvoluted, matrix]   
