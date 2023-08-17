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
      default: [20,40,80]#[10,20,40,60,80,100]
   mrna-perms:
      type: string[]
      default: ['1','2','3','4','5','6','7','8','9','10','pbmc']
   prot-perms:
      type: string[]
      default: ['1','2','3']##,'4','5']
   prot-algorithms:
      type: string[]
      default:
      - mcpcounter
    #  - xcell
    #  - epic
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
     run: sim-loop.cwl #call-deconv-on-sim.cwl
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
     run: sim-loop.cwl #call-deconv-on-sim.cwl
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
   arrayBusiness:
     run:
      class: ExpressionTool
      inputs:
        arrayTwoDim:
          type:
            type: array
            items:
              type: array
              items: File
          inputBinding:
            loadContents: true
      outputs:
         array1d:
          type: File[]
      expression: >
          ${
             var newArray= [];
             for (var i = 0; i < inputs.arrayTwoDim.length; i++) {
                for (var k = 0; k < inputs.arrayTwoDim[i].length; k++) {
                   newArray.push((inputs.arrayTwoDim[i])[k]);
            }
          }
          return { 'array1d' : newArray }
          }
     in:
       arrayTwoDim:
        source:
           - run-all-algs-by-mrna/cell-cor-files
           - run-all-algs-by-prot/cell-cor-files
        linkMerge: merge_flattened
        pickValue: all_non_null
     out: [array1d]
   get-celltype-cors:
      run: ../figures/plot-figs.cwl
      in:
        metricType:
            valueFrom: "cellType"
        files:
            source: arrayBusiness/array1d
        #    type:
        #      type: array
        #      items:
        #         type: array
        #         items: File
        #    source:
        #      - run-all-algs-by-mrna/cell-cor-files
        #      - run-all-algs-by-prot/cell-cor-files
        #    linkMerge: merge_flattened
        #    pickValue: all_non_null
      out:
         [table,fig]
