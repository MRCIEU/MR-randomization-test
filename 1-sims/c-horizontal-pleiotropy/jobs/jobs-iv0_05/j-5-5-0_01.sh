#!/bin/bash
#PBS -l walltime=120:00:00,nodes=1:ppn=10
#PBS -o out-5-5-0_01.file
#PBS -t 1-6
#---------------------------------------------

date


cd $PBS_O_WORKDIR

cd ../../

# get settings
settingLine=${PBS_ARRAYID}

rsqC=`cat jobs/settings-hp.txt | sed -n ${settingLine}p | cut -d, -f1`
numhpSnps=`cat jobs/settings-hp.txt | sed -n ${settingLine}p | cut -d, -f2`
numnonhpSnps=`cat jobs/settings-hp.txt | sed -n ${settingLine}p | cut -d, -f3`
covarsInc=`cat jobs/settings-hp.txt | sed -n ${settingLine}p | cut -d, -f4`

module add languages/R-4.0.3-gcc9.1.0


export RES_DIR="${HOME}/2021-randomization-test/results"


ncHP=5
ncnotHP=5
ivEffect=0.05



Rscript sim-hp.R $ncHP $ncnotHP $rsqC $numhpSnps $numnonhpSnps $ivEffect "dosage" $covarsInc 0.01

date


