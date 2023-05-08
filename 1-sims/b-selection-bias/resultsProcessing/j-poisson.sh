#!/bin/bash

#SBATCH --job-name=j-poisson
#SBATCH --partition=veryshort
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=6:0:0
#SBATCH --mem=100G
#SBATCH --account=ACC1234

#---------------------------------------------

date


cd $SLURM_SUBMIT_DIR

module add languages/r/4.2.1

export RES_DIR="${HOME}/2021-randomization-test/results"

Rscript mainSummarisePoisson.R

date

# plot results
module add apps/matlab/2021a

matlab -r plotPoissonResults


date

