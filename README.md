
# Mendelian randomization – randomization test





## Environment details

I use the following language versions: R-4.0.3, matlab r2019a.

The code is run on the University of Bristol's HPC service (on BlueCrystal phase 3 unless otherwise stated).

```bash
module add languages/R-4.0.3-gcc9.1.0
module add apps/matlab-r2019a
```

The code uses some environment variables, which needs to be set in your linux environment. 

The results and project data directories are temporarily set with:

```bash
export RES_DIR="${HOME}/2021-randomization-test/results"
export PROJECT_DATA="${HOME}/2021-randomization-test/data"
```


## Code overview

The study has two components - a simulation study and an example applied analysis.
Please see the `1-sims' and `2-applied' directories for the code and documentation for each.
