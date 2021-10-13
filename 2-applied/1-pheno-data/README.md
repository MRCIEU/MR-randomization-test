

## Extract phenotypes

For selection bias applied example:

```bash
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'eid'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x21022_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x31_'
# sep factors
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x20116_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x189_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x845_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x6138_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x21001_'
# mental health traits
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x130895_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x20127_'
```


Extract phenotypes:

```bash
cut -d',' -f 1,11,414,718-720,4284-4289,8195-8198,8211,9075-9078,9093,20703 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv > ${PROJECT_DATA}/phenotypes/original/phenos-selection.csv
```



