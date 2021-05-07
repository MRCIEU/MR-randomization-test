#!/bin/bash
#PBS -l walltime=12:00:00,nodes=1:ppn=1
#PBS -o out-testFixTotalEffect_binaryS_r0_4.file
#---------------------------------------------

date

cd $PBS_O_WORKDIR

module add languages/R-4.0.3-gcc9.1.0


export RES_DIR="${HOME}/2021-randomization-test/results"

Rscript testFixTotalEffect_binaryS.R 0.4

date

