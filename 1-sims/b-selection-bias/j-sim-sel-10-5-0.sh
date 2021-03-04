#!/bin/bash
#PBS -l walltime=12:00:00,nodes=1:ppn=1
#PBS -o out-sim-sel-10-5-0.file
#---------------------------------------------

date


cd $PBS_O_WORKDIR

module add languages/R-4.0.3-gcc9.1.0


export RES_DIR="${HOME}/2021-randomization-test/results"

Rscript sim-selection.R 10 5 0 

date
