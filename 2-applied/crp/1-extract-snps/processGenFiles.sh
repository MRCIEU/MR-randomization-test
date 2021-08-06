snpDir="${PROJECT_DATA}/genetic/"


#### Combine into single bgen file:

cat $PROJECT_DATA/genetic/snp-out*.gen > $PROJECT_DATA/genetic/snp-out-allv1.gen

# check number of snps
wc -l $PROJECT_DATA/genetic/snp-out-allv1.gen


# remove other snp for rs7121935

grep -v "11:72496148_G_T" $PROJECT_DATA/genetic/snp-out-allv1.gen > $PROJECT_DATA/genetic/snp-out-all.gen

# check number of snps
wc -l $PROJECT_DATA/genetic/snp-out-all.gen


#### Convert to dosages

cat $PROJECT_DATA/genetic/snp-out-all.gen | python gen_to_expected.py > $PROJECT_DATA/genetic/snps-all-dosage.txt


####
# check the number of fields
awk '{print NF}' ${snpDir}snps-all-dosage.txt

####
# Remove the first 6 columns from SNP file, that we don't need
cut -d' ' -f 7- ${snpDir}snps-all-dosage.txt > ${snpDir}snps-all-dosage2.txt

####
# Transpose the data so the SNPs are columns and the participants are rows
matlab -r doTranspose


######
###### USER ID preparation

####
# get user ID column from sample file (all sample files should be the same)

ddir="${UKB_DATA_RDSF}/genetic/variants/arrays/imputed/released/2018-09-18/data/dosage_bgen"
sampleFile="${ddir}/data.chr1-22.sample"

awk '(NR>2) {print $1}' $sampleFile > ${snpDir}pIds.txt


######
###### Add user ids to pheno data


# Get the SNP names and make this the header row of the snp data file

cut -d' ' -f 3 ${snpDir}snps-all-dosage.txt >${snpDir}snp-names.txt
tr '\n' ',' < ${snpDir}snp-names.txt > ${snpDir}snp-data.txt

# remove last comma and add new line to file
sed -i 's/,$//g' ${snpDir}snp-data.txt
sed -i 's/$/\n/g' ${snpDir}snp-data.txt
sed -i 's/^/pId,/g' ${snpDir}snp-data.txt


# Join the SNP data with the user ID column and append this to the snp data file:
cat ${snpDir}snps-all-dosage-transposed.txt | paste -d',' ${snpDir}pIds.txt -  >> ${snpDir}snp-data.txt


####
#### basic checking

# number of columns should be number of SNPs + 1 (user id column)
awk -F, '{print NF}' ${snpDir}snp-data.txt | head

# number of rows should be number of people + 1 (header row)
wc -l ${snpDir}snp-data.txt
