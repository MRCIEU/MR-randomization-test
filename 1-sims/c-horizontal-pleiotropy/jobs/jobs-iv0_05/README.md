
## Horizontal pleiotropy simulations


This directory contains job files, to run the horizontal pleiotropy simulations.

We run these jobs on Blue Crystal phase 3 (https://www.acrc.bris.ac.uk/acrc/phase3.htm).

The file names take the form j-[ncHP-ncnotHP-snpEffect.sh, where ncHP is the number of covariates affected by the SNP, 
ncnotHP is the number of covaries not affected by the snp, and snpEffect is the r^2 for the effect of the SNP on covariates.

The jobs can be submitted to the job scheduler with the following commands:

```bash
qsub j-1-1.sh
qsub j-1-1-0_1.sh
qsub j-1-1-0_01.sh
qsub j-1-1-0_005.sh
qsub j-1-5.sh    
qsub j-1-5-0_1.sh
qsub j-1-5-0_01.sh
qsub j-1-5-0_005.sh
qsub j-5-1.sh    
qsub j-5-1-0_1.sh
qsub j-5-1-0_01.sh
qsub j-5-1-0_005.sh
qsub j-5-5.sh
qsub j-5-5-0_1.sh
qsub j-5-5-0_01.sh
qsub j-5-5-0_005.sh
```
