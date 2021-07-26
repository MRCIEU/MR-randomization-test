#!/bin/bash
#PBS -l walltime=3:00:00,nodes=1:ppn=10
#PBS -o out-2-0.file
#PBS -t 1-15
#---------------------------------------------

date


cd $PBS_O_WORKDIR

cd ../../

# get settings
settingLine=${PBS_ARRAYID}

rsqC=`cat jobs/settings.txt | sed -n ${settingLine}p | cut -d, -f1`
rsqS=`cat jobs/settings.txt | sed -n ${settingLine}p | cut -d, -f2`
covarsInc=`cat jobs/settings.txt | sed -n ${settingLine}p | cut -d, -f3`


module add languages/R-4.0.3-gcc9.1.0


export RES_DIR="${HOME}/2021-randomization-test/results"


ncs=2
ncnots=0


# ncs ncnots rc rSelection
Rscript sim-selection.R $ncs $ncnots $rsqC $rsqS 0.1 "grs" $covarsInc

date

