#!/bin/bash
#PBS -l walltime=12:00:00,nodes=1:ppn=1
#PBS -o out-sim-corrs.file
#---------------------------------------------

date



####PBS -t 1-10


cd $PBS_O_WORKDIR

module add languages/R-4.0.3-gcc9.1.0

#ix=${PBS_ARRAYID}
#ixStart=$((ix*100-99))
#ixEnd=$((ixStart+100-1))


export RES_DIR="${HOME}/2021-randomization-test/results"

Rscript sim-branson-corrs.R 

date




