

## Extract phenotypes

For selection bias applied example:

```bash
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'eid'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x21022_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x31_'
# sep factors
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x189_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x845_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x6138_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x21001_'
# height
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x50_'
# northing and easting locations
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x20074_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x20075_'
```


Extract phenotypes:

```bash
cut -d',' -f 1,11,33,414,718-720,4284-4289,7230,7233,9075-9078,9093 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv > ${PROJECT_DATA}/phenotypes/original/phenos-selection.csv
```



For horizontal pleiotropy applied example:

BMI, SBP, DBP, total cholesterol, hdl cholesterol, apolipoprotein A1, apolipoprotein B, albumin, lipoprotein A, Leukocyte count, glucose, smoking pack years, weight, height and waist hip ratio.


```bash
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'eid'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x21001_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x93_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x4080_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x94_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x4079_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x30690_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x30760_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x30630_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x30640_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x30600_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x30790_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x30740_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x30000_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x20160_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x20161_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x21002_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x50_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x48_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep 'x49_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep '20002'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep '6150'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep '131296'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep '131307'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv | sed 's/,/\n/g' | cat -n | grep '30710'

```


Extract phenotypes:

```bash
cut -d',' -f 1,25-36,355-370,1740-1755,5852-5987,4516-4527,8333-8340,9075-9082,16273-16275,16397,16398,16403-16406,16415,16416,16419,16420,16425,16426,16429,16430,16435,16436,21099-21110 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-09-14/data/data.48196.phesant.csv > ${PROJECT_DATA}/phenotypes/original/phenos-hp.csv
```



## Derive phenotypes from raw data


```bash
Rscript prepPhenosSelection.R
Rscript prepPhenosHP.R
```
