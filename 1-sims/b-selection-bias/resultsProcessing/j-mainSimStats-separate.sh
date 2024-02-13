#!/bin/bash

#SBATCH --job-name=j-mainSimStatsX
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

#Rscript mainSimStats.R


# plot results
module add apps/matlab/2021a
matlab -r "resFileName='sim-resFIX';testName='bonf';plotResSeparate"
matlab -r "resFileName='sim-resFIX';testName='bran';plotResSeparate"
matlab -r "resFileName='sim-resFIX';testName='indl';plotResSeparate"
matlab -r "resFileName='sim-resFIX';testName='indr';plotResSeparate"



date

