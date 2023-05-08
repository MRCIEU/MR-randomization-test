
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
sbatch j-poisson.sh
```


## Sensitivity with 0.1 P value theshold

Generates power using P 0.1 threshold rather than 0.05 used above.

```bash
sbatch j-mainSimStatsThresh0_1.sh
```
