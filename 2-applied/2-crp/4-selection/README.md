
# Apply randomization test for selection bias with CRP GRS



# Restricted set

Covariates: Age and sex only

```bash
Rscript doRandomizationTest.R "agesex"
```

# Lenient set

Covariates: Age, sex, SEP (townsend deprivation index, education, smoking), and 
mental health traits (neuroticism and depression).


```bash
Rscript doRandomizationTest.R "all"
```

