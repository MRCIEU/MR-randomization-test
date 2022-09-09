#!/bin/bash
#PBS -l walltime=4:00:00,nodes=1:ppn=1
#PBS -o outputagesex
#PBS -e errorsagesex
#---------------------------------------------

date

module add languages/R-4.0.3-gcc9.1.0

export RES_DIR="${HOME}/2021-randomization-test/results"
export PROJECT_DATA="${HOME}/2021-randomization-test/data"


cd $PBS_O_WORKDIR

Rscript doRandomizationTest.R "agesex"

date


