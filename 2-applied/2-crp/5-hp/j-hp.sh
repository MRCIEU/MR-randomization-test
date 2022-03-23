#!/bin/bash

#SBATCH --job-name=applied_hp
#SBATCH --partition=veryshort
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=14
#SBATCH --time=6:0:0
#SBATCH --mem=100G

#---------------------------------------------

date

module load languages/r/4.1.0

export RES_DIR="${HOME}/2021-randomization-test/results"
export PROJECT_DATA="${HOME}/2021-randomization-test/data"


cd $SLURM_SUBMIT_DIR

Rscript doRandomizationTest.R

date


