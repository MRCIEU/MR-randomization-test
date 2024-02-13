

# Process and plot selection simulation results



## Main results in selected subsample

```bash
Rscript mainSimStats.R
```




Plot results:

```bash
matlab -r plotRes
```

```bash
matlab -r plotResNotHP
```

Plotting results of tests on separate plots for main paper:
```bash
matlab -r "resFileName='sim-res';testName='bran';plotResSeparate"
matlab -r "resFileName='sim-res';testName='bonf';plotResSeparate"
matlab -r "resFileName='sim-res';testName='indl';plotResSeparate"
matlab -r "resFileName='sim-res';testName='indr';plotResSeparate"
```

## Sensitivity with 0.1 P value theshold

```bash
sbatch j-mainSimStatsThresh0_1.sh
```
