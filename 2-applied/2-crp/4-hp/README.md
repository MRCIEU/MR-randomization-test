
# Apply randomization test for horizontal pleiotropy with CRP SNPs


## Run randomization test for each CRP SNP

The covariate set used in the randomization test includes:
BMI, systolic blood pressure (SBP), diastolic blood pressure (DBP), total cholesterol, HDL cholesterol, apolipoprotein A1, apolipoprotein B, albumin, lipoprotein A$

The randomization test is run with this covariate set on BlueCrystal using the following command: 

```bash
qsub j-hp.sh
```


## Calculate number of independent tests

The numIndep script calculates the effective number of independent phenotypes in the covariate set, using spectral decomposition.

```bash
Rscript numIndep.R
```


## MR analysis

Create dataset with variables we need for MR:

```bash
Rscript mrdata.R
```

Run MR using IV probit regression:

```bash
stata runMR.do
```

Plot MR results:

```bash
matlab -r plotMR
```
