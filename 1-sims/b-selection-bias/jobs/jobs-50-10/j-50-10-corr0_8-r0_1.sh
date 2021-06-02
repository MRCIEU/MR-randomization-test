#!/bin/bash
#PBS -l walltime=360:00:00,nodes=1:ppn=10
#PBS -o out-50-10-corrC0_8-r0_1.file
#---------------------------------------------

date


cd $PBS_O_WORKDIR
cd ../..

module add languages/R-4.0.3-gcc9.1.0


export RES_DIR="${HOME}/2021-randomization-test/results"

# ncs ncnots corrC rSelection
Rscript sim-selection.R 50 10 0.8 0.1

date

