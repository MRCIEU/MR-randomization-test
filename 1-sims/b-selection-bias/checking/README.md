

## Check MD approach

Check monotonicity of the Mahalanobis distance (MD) we generate using a regression against the MD 
generated using the getMD function in the ivmodel package.

```bash
Rscript testMD.R
```

```bash
matlab -r plottest
```



## Check the rsq and distribution of derived variables

```bash
qsub j-testFixTotalEffect_binaryX.sh
qsub j-testFixTotalEffect_continuousX.sh
qsub j-testFixTotalEffect_continuousY.sh
qsub j-testFixTotalEffect_binaryS.sh
```

Then these are the versions fixing the IV strength also (i.e. fixing the amount of variance
in X explained by Z):

```bash
qsub j-testFixTotalEffect_continuousX2.sh
qsub j-testFixTotalEffect_continuousY.sh
qsub j-testFixTotalEffect_binaryS.sh
```
