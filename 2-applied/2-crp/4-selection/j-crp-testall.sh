#!/bin/bash

#SBATCH --job-name=rand_sel_all
#SBATCH --partition=test
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-1:0:0
#SBATCH --mem=1G

#---------------------------------------------

date

module add languages/r/4.1.0

export RES_DIR="${HOME}/2021-randomization-test/results"
export PROJECT_DATA="${HOME}/2021-randomization-test/data"


cd $SLURM_SUBMIT_DIR

Rscript doRandomizationTest.R "all"

date


