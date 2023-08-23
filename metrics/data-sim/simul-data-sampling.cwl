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
#   num-reps:
#      type: int
#      default: 10
   samples:
      type: int[]
      default: [10,20,40,60,80,100]
   mrna-perms:
      type: string[]
      default: ['1','2','3','4','5']#,'6','7','8','9','10','pbmc']
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
   repNumber:
      type: int
      default: 0

outputs:
   cell-cor-tab:
      type: File
      outputSource: get-celltype-cors/table
   cell-fig:
      type: File[]
      outputSource: get-celltype-cors/fig

steps:
   run-all-algs-by-mrna:
     run: call-deconv-on-sim.cwl #call-deconv-on-sim.cwl
     when: $(inputs.simType.trim() == 'mrna')
     scatter: [protAlg,simulation,signature,sample]
     scatterMethod: flat_crossproduct
     in:
        protAlg: prot-algorithms
        simulation: mrna-perms
        signature: rna-sigs
        sample: samples
        sampleType:
          valueFrom: 'normal'
        dataType:
          valueFrom: 'prot'
        simType: simType
     out:
       [cell-cor-files]
   run-all-algs-by-prot:
     run: call-deconv-on-sim.cwl
     when: $(inputs.simType.trim() == 'prot')
     scatter: [protAlg,simulation,signature,sample]
     scatterMethod: flat_crossproduct
     in:
        protAlg: prot-algorithms
        simulation: prot-perms
        sample: samples
        signature: prot-sigs
        sampleType:
          valueFrom: 'normal'
        dataType:
          valueFrom: 'prot'
        simType: simType
     out:
        [cell-cor-files]
   get-celltype-cors:
      run: ../figures/plot-figs.cwl
      in:
        metricType:
            valueFrom: "cellType"
        files:
            source:
              - run-all-algs-by-mrna/cell-cor-files
              - run-all-algs-by-prot/cell-cor-files
            linkMerge: merge_flattened
            pickValue: all_non_null
        repNumber:
            source: repNumber
      out:
         [table,fig]
