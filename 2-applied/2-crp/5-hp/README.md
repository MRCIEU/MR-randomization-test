
# Apply randomization test for horizontal pleiotropy with CRP SNPs


## Run randomization test for each CRP SNP

```bash
qsub j-hp.sh
```





## Calculate number of independent tests

```bash
Rscript numIndep.R
```


## MR analysis

Create dataset with variables we need for MR:

```bash
Rscript mrdata.R
```

Run MR:

```bash
stata runMR.do
```

Plot MR results:

```bash
matlab -r plotMR
```
