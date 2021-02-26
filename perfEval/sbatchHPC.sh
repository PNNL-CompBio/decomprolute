#!/bin/sh

#SBATCH -A hyperbio
#SBATCH -t 168:00:00
#SBATCH -N 1
#SBATCH -n 24
#SBATCH -p slurm7
#SBATCH -J imputation
#SBATCH -o imputation.log
#SBATCH -e imputation.err


module purge
module load python/anaconda3.2019.3
source /share/apps/python/anaconda3.2019.3/etc/profile.d/conda.sh
conda init zsh
conda activate omics

export PATH=/people/feng626/.conda/envs/omics/bin:$PATH

export PATH=/people/feng626/.nvm/versions/node/v15.8.0/bin:$PATH

module load singularity/3.6.3

export SINGULARITY_HOME=/pic/scratch/feng626/singularity
export SINGULARITYENV_HOME=/pic/scratch/feng626/singularity
export SINGULARITY_CACHEDIR=/pic/scratch/feng626/singularity/singularity_cache
export SINGULARITYENV_CACHEDIR=/pic/scratch/feng626/singularity/singularity_cache
export SINGULARITY_TMPDIR=/pic/scratch/feng626/singularity/singularity_tmp
export SINGULARITYENV_TMPDIR=/pic/scratch/feng626/singularity/singularity_tmp
export CWL_SINGULARITY_CACHE=/pic/scratch/feng626/singularity/singularity_cwl

export XDG_RUNTIME_DIR=/nonexistent

cd /pic/scratch/feng626/proteomicsTumorDeconv/perfEval

cwltool --singularity scatter-imputation.cwl fig4-eval.yml
# cwltool --singularity --parallel scatter-imputation.cwl fig4-eval.yml





