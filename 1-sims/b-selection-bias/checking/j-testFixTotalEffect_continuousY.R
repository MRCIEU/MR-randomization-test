#!/bin/bash
#PBS -l walltime=6:00:00,nodes=1:ppn=1
#PBS -o out-testFixTotalEffect_continuousY.file
#---------------------------------------------

date

cd $PBS_O_WORKDIR

module add languages/R-4.0.3-gcc9.1.0


export RES_DIR="${HOME}/2021-randomization-test/results"

Rscript testFixTotalEffect_continuousY.R

date

