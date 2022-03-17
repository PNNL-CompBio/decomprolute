#!/usr/bin/env cwltool
class: Workflow
label: simul-data-comparison
id: simul-data-comparison
cwlVersion: v1.2

requirements:
   - class: SubworkflowFeatureRequirement
   - class: MultipleInputFeatureRequirement
   - class: ScatterFeatureRequirement
   - class: StepInputExpressionRequirement
   - class: InlineJavascriptRequirement

inputs: 
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
   cell-cor-tab:
      type: File
      outputSource: get-celltype-cors/table
   cell-fig:
      type: File[]
      outputSource: get-celltype-cors/fig

steps:
   run-all-algs-by-mrna:
     run: call-deconv-on-sim.cwl
     when: $(inputs.simType.trim() == 'mrna')
     scatter: [protAlg,permutation,signature]
     scatterMethod: flat_crossproduct
     in:
        protAlg: prot-algorithms
        permutation: mrna-perms
        signature: rna-sigs
        sampleType:
          valueFrom: 'normal'
        dataType:
          valueFrom: 'prot'
        simType: simType
     out:
        [cell-cor-file,mat-dist-file, deconv, cellPred, deconvoluted, matrix]
   run-all-algs-by-prot:
     run: call-deconv-on-sim.cwl
     when: $(inputs.simType.trim() == 'prot')
     scatter: [protAlg,permutation,signature]
     scatterMethod: flat_crossproduct
     in:
        protAlg: prot-algorithms
        permutation: prot-perms
        signature: prot-sigs
        sampleType:
          valueFrom: 'normal'
        dataType:
          valueFrom: 'prot'
        simType: simType
     out:
        [cell-cor-file,mat-dist-file, deconv, cellPred, deconvoluted, matrix]   
   get-celltype-cors:
      run: ../figures/plot-figs.cwl
      in:
        metricType:
            valueFrom: "cellType"
        files:
            source:
              - run-all-algs-by-mrna/cell-cor-file
              - run-all-algs-by-prot/cell-cor-file
            pickValue: first_non_null
      out:
         [table,fig]
#   get-celltype-cordists:
#      run: ../figures/plot-figs.cwl
#      in:
#        metric:
#            valueFrom: "meanCorrelation"
#        metricType:
#            valueFrom: "cellType"
#        files:
#            source: run-all-algs-by-sig/cell-cor-file
#      out:
#         [table,fig]

