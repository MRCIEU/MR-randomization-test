
datadir=Sys.getenv('PROJECT_DATA')


phenos = read.table(paste0(datadir, "/phenotypes/original/phenos.tab"), sep="\t", header=1)



# sex
colnames(phenos)[which(colnames(phenos)=="x31_0_0")] = "male"

# age
summary(phenos$x21022_0_0)
colnames(phenos)[which(colnames(phenos)=="x21022_0_0")] = "age"

# depression
phenos$hasDepression = 0
phenos$hasDepression[which(!is.na(phenos$x130895_0_0))] = 1
table(phenos$hasDepression)
phenos$x130895_0_0 = NULL

# neuroticism score
print('Neuroticism score')
summary(phenos$x20127_0_0)
colnames(phenos)[which(colnames(phenos)=="x20127_0_0")] = "neurot_score"



# bmi
summary(phenos$x21001_0_0)
colnames(phenos)[which(colnames(phenos)=="x21001_0_0")] = "bmi"

# townsend
colnames(phenos)[which(colnames(phenos)=="x189_0_0")] = "townsend"

# smoking
colnames(phenos)[which(colnames(phenos)=="x20116_0_0")] = "smoke"
table(phenos$smoke)
phenos$smoke[which(phenos$smoke == -3)] = NA
table(phenos$smoke)

# education
ednames = c('college', 'alevels', 'gcse', 'cse', 'nvq', 'other_profes')
for (i in 1:6) {
  colname = paste('ed', i, ednames[i], sep='')
  phenos[,colname] = NA
  ix = which(phenos$x6138_0_0 >0 | phenos$x6138_0_0 == -7)
  phenos[ix,colname] = 0
  ix = which(phenos$x6138_0_0 == i | phenos$x6138_0_1 == i | phenos$x6138_0_2 == i | phenos$x6138_0_3 == i | phenos$x6138_0_4 == i | phenos$x6138_0_5 == i)
  phenos[ix,colname] = 1
}
phenos$x6138_0_0 = NULL
phenos$x6138_0_1 = NULL
phenos$x6138_0_2 = NULL
phenos$x6138_0_3 = NULL
phenos$x6138_0_4 = NULL
phenos$x6138_0_5 = NULL


write.table(phenos, paste0(datadir, "/phenotypes/derived/phenos.csv"), col.names=TRUE, row.names=FALSE, sep=',')
