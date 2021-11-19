
# Process and plot selection simulation results



## Main results in selected subsample

```bash
Rscript mainSimStats.R
```

Plot results:

```bash
matlab -r "resFileName='sim-res';plotRes"
```

## Results in whole sample

To check that p~0.05 when the covariates aren't associated with the IV (i.e. there is no selection bias).

```bash
Rscript mainSimStatsNoSelection.R
```

Plot results:

```bash
matlab -r "resFileName='sim-res-allparticipants';plotRes"
```





## Poisson regression results

These results are estimates of the interaction between covariates and the outcome, in their effect of selection.
This is what drives the selection bias.

```bash
Rscript mainSummarisePoisson.R
```

```bash
matlab -r plotPoissonResults
```
