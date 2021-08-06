

# Extracting 58 CRP SNPs from UKB genetic data
 
The two snp lists are from Table 1 and Table S3 in the [Ligthart CRP GWAS](https://www.sciencedirect.com/science/article/pii/S0002929718303203).


## Create single list of snps

```bash
awk '(NR>1) {print $1}' snp-list-s3.txt > snps.txt
awk '(NR>1) {print $1}' snp-list-table1.txt >> snps.txt
```

## Extract snps

Make temporary directory:

```
mkdir ~/tmp-rand/
```


Copy sample file to tmp dir:

```
cp $UKB_DATA_RDSF/genetic/variants/arrays/imputed/released/2018-09-18/data/dosage_bgen/data.chr1-22.sample ~/tmp-rand/
```

```
qsub j-extract.sh
```

Combine into single bgen file:

```bash
cat $PROJECT_DATA/genetic/snp-out*.gen > $PROJECT_DATA/genetic/snp-out-all.gen
wc -l $PROJECT_DATA/genetic/snp-out-all.gen
```


## Convert to dosages

```bash
cat $PROJECT_DATA/genetic/snp-out-all.gen | python gen_to_expected.py > $PROJECT_DATA/genetic/snps-all-dosage.txt
```


