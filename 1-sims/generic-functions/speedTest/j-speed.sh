#!/bin/bash

#SBATCH --job-name=speed_test
#SBATCH --partition=veryshort
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0:10:0
#SBATCH --mem=1G


module add languages/r/4.1.2

cd $SLURM_SUBMIT_DIR

Rscript speedMeanDiffs.r

