
# Apply randomization test for selection bias with CRP GRS

We use two sets of covariates, a restricted set and a more liberal set.

# Restricted set

The restricted covariate set includes age and sex only.

The randomization test is run with this covariate set on BlueCrystal using the following command: 

```bash
qsub j-crp-testagesex.sh
```

# Liberal set

The liberal Covariate set includes age, sex, and SEP variables (townsend deprivation index, education, smoking). 

The randomization test is run with this covariate set on BlueCrystal using the following command:

```bash
j-crp-testall.sh
```


## Get equivalent number of independent phenotypes

The numIndep script calculates the effective number of independent phenotypes in each covariate set, using spectral decomposition.

```bash
Rscript numIndep.R
```
