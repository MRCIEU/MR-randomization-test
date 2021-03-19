#!/bin/bash
#PBS -l walltime=30:00:00,nodes=1:ppn=10
#PBS -o out-sim-sel-10-5-0_8-OR1_1.file
#---------------------------------------------

date


cd $PBS_O_WORKDIR
cd ..

module add languages/R-4.0.3-gcc9.1.0


export RES_DIR="${HOME}/2021-randomization-test/results"

Rscript sim-selection.R 10 5 0.8 1.1 

date

