#!/bin/sh

#SBATCH -A hyperbio
#SBATCH -t 168:00:00
#SBATCH -N 1
#SBATCH -n 8
#SBATCH -p slurm7
#SBATCH -J imput
#SBATCH -o imput.log
#SBATCH -e imput.err


module purge
module load python/anaconda3.2019.3
source /share/apps/python/anaconda3.2019.3/etc/profile.d/conda.sh
conda init zsh
conda activate omics

export PATH=/people/feng626/.conda/envs/omics/bin:$PATH

export PATH=/people/feng626/.nvm/versions/node/v15.8.0/bin:$PATH

module load singularity/3.6.3

export SINGULARITY_HOME=/people/feng626/.singularity
export SINGULARITYENV_HOME=/people/feng626/.singularity
export SINGULARITY_CACHEDIR=/people/feng626/.singularity/cache
export SINGULARITYENV_CACHEDIR=/people/feng626/.singularity/cache
export SINGULARITY_TMPDIR=/people/feng626/.singularity/tmp
export SINGULARITYENV_TMPDIR=/people/feng626/.singularity/tmp
export CWL_SINGULARITY_CACHE=/people/feng626/.singularity/cwl

export XDG_RUNTIME_DIR=/people/feng626/tmp

cd /people/feng626/proteomicsTumorDeconv/perfEval

#toil-cwl-runner --singularity --outdir ./fig4 --workDir $PWD --tmpdir-prefix tmp/runtime  scatter-imputation.cwl fig4-eval.yml
cwltool --singularity --outdir fig4 --tmpdir-prefix tmp/runtime --basedir $PWD --cachedir .cache scatter-imputation.cwl fig4-test.yml

