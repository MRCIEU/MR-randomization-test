datadir=Sys.getenv('PROJECT_DATA')
resdir=Sys.getenv('RES_DIR')



## covariates for selection applied example

phenos = read.table(paste0(datadir, "/phenotypes/derived/phenos-selection.csv"), sep=",", header=1)


phenos = phenos[,c('male', 'age', 'townsend', 'eduyears', 'smoke', 'neurot_score', 'hasDepression')]

phenoCor = cor(phenos, use="pairwise.complete.obs")

phenoCor = format(round(phenoCor, 3), nsmall = 3)
write.table(phenoCor, paste0(resdir, "/pheno-cor-selection.csv"), col.names=TRUE, row.names=TRUE, sep='\t', quote=FALSE)




## covariates for HP applied example

phenos = read.table(paste0(datadir, "/phenotypes/derived/phenos-hp.csv"), sep=",", header=1)

phenos = phenos[,c("smok_pack_years","bmi","weight","height","leuk_count","albumin","apolip_a","apolip_b","chol","glucose","chol_hdl","lipo_a","sbp","dbp","waisthip")]

phenoCor = cor(phenos, use="pairwise.complete.obs")

phenoCor = format(round(phenoCor, 3), nsmall = 3)
write.table(phenoCor, paste0(resdir, "/pheno-cor-hp.csv"), col.names=TRUE, row.names=TRUE, sep='\t', quote=FALSE)

