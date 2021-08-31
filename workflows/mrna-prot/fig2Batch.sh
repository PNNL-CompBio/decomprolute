#!/bin/sh

#SBATCH -A br21_gosl241
#SBATCH -t 168:00:00
#SBATCH -N 1
#SBATCH -n 24
#SBATCH -p slurm7
#SBATCH -J fig2
#SBATCH -o fig2.log
#SBATCH -e fig2.err


module purge
module load singularity/3.6.3
module load python/anaconda3.2019.3
source /share/apps/python/anaconda3.2019.3/etc/profile.d/conda.sh
#conda init bash

export PATH=/people/gosl241/.conda/envs/toil/bin:$PATH
export NVM_DIR="$HOME/.nvm"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export SINGULARITY_HOME=$HOME/singularity
export SINGULARITYENV_HOME=$HOME/singularity
export SINGULARITY_CACHEDIR=$HOME/.singularity
export SINGULARITYENV_CACHEDIR=$HOME/.singularity
export CWL_SINGULARITY_CACHE=$HOME/.singularity/cwl

mkdir $HOME/temp

export XDG_RUNTIME_DIR=$HOME/temp



cd /people/gosl241/proteomicsTumorDeconv/perfEval


toil-cwl-runner --singularity --workDir ./ --maxCores 10 scatter-test.cwl fig2-eval.yml

