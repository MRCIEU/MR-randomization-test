
# Apply randomization test for selection bias with CRP GRS



# Restricted set

Covariates: Age and sex only

```bash
qsub j-crp-testagesex.sh
```

# Lenient set

Covariates: Age, sex, SEP (townsend deprivation index, education, smoking), and 
mental health traits (neuroticism and depression).


```bash
j-crp-testall.sh
```


## Get equivalent number of independent phenotypes


```bash
Rscript numIndep.R
```
