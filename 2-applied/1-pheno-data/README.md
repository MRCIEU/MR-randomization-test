

## Extract phenotypes


```bash
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-02-24/data/data.43017.phesant.tab | sed 's/\t/\n/g' | cat -n | grep 'eid'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-02-24/data/data.43017.phesant.tab | sed 's/\t/\n/g' | cat -n | grep 'x21022_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-02-24/data/data.43017.phesant.tab | sed 's/\t/\n/g' | cat -n | grep 'x31_'
# sep factors
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-02-24/data/data.43017.phesant.tab | sed 's/\t/\n/g' | cat -n | grep 'x20116_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-02-24/data/data.43017.phesant.tab | sed 's/\t/\n/g' | cat -n | grep 'x189_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-02-24/data/data.43017.phesant.tab | sed 's/\t/\n/g' | cat -n | grep 'x6138_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-02-24/data/data.43017.phesant.tab | sed 's/\t/\n/g' | cat -n | grep 'x21001_'
# mental health traits
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-02-24/data/data.43017.phesant.tab | sed 's/\t/\n/g' | cat -n | grep 'x130895_'
head -n 1 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-02-24/data/data.43017.phesant.tab | sed 's/\t/\n/g' | cat -n | grep 'x20127_'
```


Extract phenotypes:

```bash
cut -d'\t' -f 1,11,7919,7935,8799,8817,4284-4289,19393,19413 ${UKB_DATA_PHENO}/phenotypic/applications/16729/released/2021-02-24/data/data.43017.phesant.tab > ${PROJECT_DATA}/phenotypes/original/phenos.tab


