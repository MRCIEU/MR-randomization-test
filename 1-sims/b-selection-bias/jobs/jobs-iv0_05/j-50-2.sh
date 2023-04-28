#!/bin/bash

#SBATCH --job-name=j50-2
#SBATCH --partition=cpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=10
#SBATCH --cpus-per-task=1
#SBATCH --time=5-0:0:0
#SBATCH --mem=100G
#SBATCH --array=1-30
#SBATCH --account=ACC1234

#---------------------------------------------

date


cd $SLURM_SUBMIT_DIR

cd ../../

# get settings
settingLine=${SLURM_ARRAY_TASK_ID}

rsqC=`cat jobs/settings.txt | sed -n ${settingLine}p | cut -d, -f1`
rsqS=`cat jobs/settings.txt | sed -n ${settingLine}p | cut -d, -f2`
covarsInc=`cat jobs/settings.txt | sed -n ${settingLine}p | cut -d, -f3`

module add languages/r/4.2.1


export RES_DIR="${HOME}/2021-randomization-test/results"


ncs=50
ncnots=2
ivEffect=0.05


# ncs ncnots rc rSelection
Rscript sim-selection.R $ncs $ncnots $rsqC $rsqS $ivEffect "grs" $covarsInc

date

