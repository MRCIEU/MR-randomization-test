
datadir=Sys.getenv('PROJECT_DATA')


phenos = read.table(paste0(datadir, "/phenotypes/original/phenos-hp.csv"), sep=",", header=1)



# bmi
print("BMI")
summary(phenos$x21001_0_0)
colnames(phenos)[which(colnames(phenos)=="x21001_0_0")] = "bmi"

# sbp
print("SBP")
phenos$sbp = rowMeans(phenos[,c("x4080_0_0","x4080_0_1")], na.rm=TRUE)
summary(phenos$sbp)
ix = which(is.na(phenos$sbp) & !is.na(phenos$x93_0_0))
phenos$sbp[ix] = rowMeans(phenos[ix,c("x93_0_0","x93_0_1")], na.rm=TRUE)
summary(phenos$sbp)

# dbp
print("DBP")
phenos$dbp = rowMeans(phenos[,c("x4079_0_0","x4079_0_1")], na.rm=TRUE)
summary(phenos$dbp)
ix = which(is.na(phenos$dbp) & !is.na(phenos$x94_0_0))
phenos$dbp[ix] = rowMeans(phenos[ix,c("x94_0_0","x94_0_1")], na.rm=TRUE)
summary(phenos$dbp)

# total cholesterol
print("total cholesterol")
colnames(phenos)[which(colnames(phenos)=="x30690_0_0")] = "chol"

# hdl cholesterol
print("hdl cholesterol")
colnames(phenos)[which(colnames(phenos)=="x30760_0_0")] = "chol_hdl"

# apolipoprotein A1
print("apolipoprotein A1")
colnames(phenos)[which(colnames(phenos)=="x30630_0_0")] = "apolip_a"

# apolipoprotein B
print("apolipoprotein B")
colnames(phenos)[which(colnames(phenos)=="x30640_0_0")] = "apolip_b"

# albumin
print("albumin")
colnames(phenos)[which(colnames(phenos)=="x30600_0_0")] = "albumin"

# lipoprotein A
print("lipoprotein A")
colnames(phenos)[which(colnames(phenos)=="x30790_0_0")] = "lipo_a"

# glucose
print("glucose")
colnames(phenos)[which(colnames(phenos)=="x30740_0_0")] = "glucose"

# leukocyte count
print("leukocyte count")
colnames(phenos)[which(colnames(phenos)=="x30000_0_0")] = "leuk_count"

# smoking pack years
print("smoking pack years")
colnames(phenos)[which(colnames(phenos)=="x20161_0_0")] = "smok_pack_years"
summary(phenos$smok_pack_years)

# set non smokers to zero
ix = which(phenos$x20160 == 0)
phenos$smok_pack_years[ix] = 0
summary(phenos$smok_pack_years)


# weight
print("weight")
colnames(phenos)[which(colnames(phenos)=="x21002_0_0")] = "weight"

# height
print("height")
colnames(phenos)[which(colnames(phenos)=="x50_0_0")] = "height"

# waist-hip ratio
print("waist-hip ratio")
phenos$waisthip = phenos$x48_0_0/phenos$x49_0_0


source('genCAD.R')
phenos = genCAD(phenos)


write.table(phenos, paste0(datadir, "/phenotypes/derived/phenos-hp.csv"), col.names=TRUE, row.names=FALSE, sep=',')
