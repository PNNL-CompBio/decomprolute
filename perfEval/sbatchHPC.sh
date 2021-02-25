#!/bin/sh

#SBATCH -A br20_feng626
#SBATCH -t 168:00:00
#SBATCH -N 1
#SBATCH -n 40
#SBATCH -J imputation
#SBATCH -o imputation.log
#SBATCH -e imputation.err


module purge
module load singularity/3.6.3
module load python/anaconda3.2019.3
source /share/apps/python/anaconda3.2019.3/etc/profile.d/conda.sh
conda init zsh
conda activate omics

export PATH=/people/feng626/.conda/envs/omics/bin:$PATH

cd /people/feng626/proteomicsTumorDeconv/perfEval

cwltool --singularity scatter-imputation.cwl fig4-eval.yml





