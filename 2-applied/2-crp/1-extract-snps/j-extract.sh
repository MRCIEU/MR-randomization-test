#!/bin/bash
#PBS -l walltime=10:00:00,nodes=1:ppn=16
#PBS -o output
#PBS -e errors
#PBS -t 2-22%1
#---------------------------------------------

date

module load languages/gcc-5.0
module load libraries/gnu_builds/gsl-1.16
module load apps/qctool-2.0

chr=$(printf "%02d" ${PBS_ARRAYID})

cd $PBS_O_WORKDIR

datadir="${HOME}/2021-randomization-test/data/genetic/"

datadirRDSF="${UKB_DATA_RDSF}/genetic/variants/arrays/imputed/released/2018-09-18/data/"



tmpdir="${HOME}/tmp-rand/"

sampleFile="${tmpdir}/data.chr1-22.sample"


# copy chromosome data to scratch space because RDSF cannot be directly used in a job
scp newblue1://${datadirRDSF}dosage_bgen/data.chr${chr}.bgen $tmpdir


# extract snps for specific chromosome
qctool -g ${tmpdir}data.chr${chr}.bgen -incl-rsids snps.txt -s $sampleFile -og ${datadir}snp-out${chr}.gen

rm $tmpdir/data.chr${chr}.bgen

date


