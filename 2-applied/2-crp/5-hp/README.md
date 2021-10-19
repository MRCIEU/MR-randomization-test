
# Apply randomization test for horizontal pleiotropy with CRP SNPs


## Run randomization test for each CRP SNP

```bash
qsub j-hp.sh
```



## Extract CAD fields and crp field

```bash
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'eid'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep '20002'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep '6150'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep '131296'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep '131307'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep '30710'

```bash
cut -d',' -f 1,5852-5987,4516-4527,16419,16420,21099-21110 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv > ${PROJECT_DATA}/phenotypes/original/phenos-hp-cad.csv
```




## Derive CAD phenotype

```bash
Rscript genCAD.R
```


## Calculate number of independent tests

```bash
Rscript numIndep.R
```


