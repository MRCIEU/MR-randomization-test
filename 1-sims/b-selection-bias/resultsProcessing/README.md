
# Process and plot selection simulation results



## Main results in selected subsample

```bash
sbatch j-mainSimStats.sh
```


## Results in whole sample

To check that p~0.05 when the covariates aren't associated with the IV (i.e. there is no selection bias).

```bash
sbatch j-mainSimStatsNoSelection.sh
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
