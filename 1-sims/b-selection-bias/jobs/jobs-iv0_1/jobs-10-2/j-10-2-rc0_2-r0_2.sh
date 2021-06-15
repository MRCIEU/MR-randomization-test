#!/bin/bash
#PBS -l walltime=10:00:00,nodes=1:ppn=10
#PBS -o out-10-2-rc0_2-r0_2.file
#---------------------------------------------

date


cd $PBS_O_WORKDIR
cd ../../../

module add languages/R-4.0.3-gcc9.1.0


export RES_DIR="${HOME}/2021-randomization-test/results"

# ncs ncnots rc rSelection
Rscript sim-selection.R 10 2 0.2 0.2

date

