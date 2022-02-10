
datadir=Sys.getenv('PROJECT_DATA')


phenos = read.table(paste0(datadir, "/phenotypes/original/phenos-selection.csv"), sep=",", header=1)



# sex
print("sex")
colnames(phenos)[which(colnames(phenos)=="x31_0_0")] = "male"

# age
print("age")
summary(phenos$x21022_0_0)
colnames(phenos)[which(colnames(phenos)=="x21022_0_0")] = "age"

# height
print("height")
summary(phenos$x50_0_0)
colnames(phenos)[which(colnames(phenos)=="x50_0_0")] = "height"

# home locations
print('home easting')
summary(phenos$x20074_0_0)
colnames(phenos)[which(colnames(phenos)=="x20074_0_0")] = "easting"

print('home northing')
summary(phenos$x20075_0_0)
colnames(phenos)[which(colnames(phenos)=="x20075_0_0")] = "northing"

# townsend
print("townsend")
colnames(phenos)[which(colnames(phenos)=="x189_0_0")] = "townsend"
summary(phenos$townsend)

# education
print("edu years")
colnames(phenos)[which(colnames(phenos)=="x845_0_0")] = "eduyears"
phenos$eduyears[which(phenos$eduyears == -2)] = NA
phenos$eduyears[which(phenos$eduyears == -1)] =	NA
phenos$eduyears[which(phenos$eduyears == -3)] =	NA
# participants with a degree are coded as leaving full-time education at at 21
ix = which(phenos$x6138_0_0 ==1 | phenos$x6138_0_1 == 1 | phenos$x6138_0_2 == 1 | phenos$x6138_0_3 == 1 | phenos$x6138_0_4 == 1 | phenos$x6138_0_5 == 1)
phenos$eduyears[ix] = 21
summary(phenos$eduyears)

write.table(phenos, paste0(datadir, "/phenotypes/derived/phenos-selection.csv"), col.names=TRUE, row.names=FALSE, sep=',')
