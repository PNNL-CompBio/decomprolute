#!/bin/sh

#SBATCH -A hyperbio
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


cd /people/gosl241/proteomicsTumorDeconv/perfEval


toil-cwl-runner --singularity scatter-test.cwl fig2-eval.yml

