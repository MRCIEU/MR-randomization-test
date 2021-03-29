#!/bin/bash
#PBS -l walltime=60:00:00,nodes=1:ppn=10
#PBS -o out-sim-sel-10-1-0_1-OR2.file
#---------------------------------------------

date


cd $PBS_O_WORKDIR
cd ..

module add languages/R-4.0.3-gcc9.1.0


export RES_DIR="${HOME}/2021-randomization-test/results"

Rscript sim-selection.R 10 1 0.1 2 

date
