#!/bin/bash

#SBATCH --job-name=j5-1-0_005
#SBATCH --partition=cpu
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=10
#SBATCH --cpus-per-task=1
#SBATCH --time=6-0:0:0
#SBATCH --mem=100G
#SBATCH --array=1-6
#SBATCH --account=ACC1234

#---------------------------------------------

date


cd $SLURM_SUBMIT_DIR

cd ../../

# get settings
settingLine=${SLURM_ARRAY_TASK_ID}

rsqC=`cat jobs/settings-hp.txt | sed -n ${settingLine}p | cut -d, -f1`
numhpSnps=`cat jobs/settings-hp.txt | sed -n ${settingLine}p | cut -d, -f2`
numnonhpSnps=`cat jobs/settings-hp.txt | sed -n ${settingLine}p | cut -d, -f3`
covarsInc=`cat jobs/settings-hp.txt | sed -n ${settingLine}p | cut -d, -f4`

module add languages/r/4.2.1


export RES_DIR="${HOME}/2021-randomization-test/results"


ncHP=5
ncnotHP=1
ivEffect=0.05



Rscript sim-hp.R $ncHP $ncnotHP $rsqC $numhpSnps $numnonhpSnps $ivEffect "dosage" $covarsInc 0.005

date


