

## Extracting 58 CRP SNPs from UKB genetic data


The SNPs come from [Ligthart 2018](https://www.sciencedirect.com/science/article/pii/S0002929718303203).
 
The two snp lists are from Table 1 and Table S3 in the [Ligthart CRP GWAS](https://www.sciencedirect.com/science/article/pii/S0002929718303203).


### Step 1: Create single list of snps

```bash
awk '(NR>1) {print $1}' snp-list-s3.txt > snps.txt
awk '(NR>1) {print $1}' snp-list-table1.txt >> snps.txt
```

## Step 2: Extract snps

To extract the SNPs we first make a temporary directory:

```
mkdir ~/tmp-rand/
```

The sample file is needed (by qctool) to extract the snps, so we first copy it into the tmp directory:


```
cp $UKB_DATA_RDSF/genetic/variants/arrays/imputed/released/2018-09-18/data/dosage_bgen/data.chr1-22.sample ~/tmp-rand/
```

Extract the SNPs from each of the chromosomes:

```
qsub j-extract.sh
```

Combine the extracted data (separate file for each chromosome) into a single bgen file:

```bash
cat $PROJECT_DATA/genetic/snp-out*.gen > $PROJECT_DATA/genetic/snp-out-all.gen
wc -l $PROJECT_DATA/genetic/snp-out-all.gen
```


## Step 3: Convert to dosages

We use the gen_to_expected.py python script to convert the SNP data to dosages, with the command:


```bash
cat $PROJECT_DATA/genetic/snp-out-all.gen | python gen_to_expected.py > $PROJECT_DATA/genetic/snps-all-dosage.txt
```


