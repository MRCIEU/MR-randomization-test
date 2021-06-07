#!/bin/bash
#PBS -l walltime=360:00:00,nodes=1:ppn=10
#PBS -o out-2-50-corrC0_4-r0_2.file
#---------------------------------------------

date


cd $PBS_O_WORKDIR
cd ../..

module add languages/R-4.0.3-gcc9.1.0


export RES_DIR="${HOME}/2021-randomization-test/results"

# ncs ncnots corrC rSelection
Rscript sim-selection.R 2 50 0.4 0.2

date

