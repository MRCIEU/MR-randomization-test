datadir=Sys.getenv('PROJECT_DATA')
resdir=Sys.getenv('RES_DIR')

phenos = read.table(paste0(datadir, "/phenotypes/derived/phenos.csv"), sep=",", header=1)


phenoCor = cor(phenos[,-1], use="complete.obs")

phenoCor = format(round(phenoCor, 3), nsmall = 3)
write.table(phenoCor, paste0(resdir, "/pheno-cor.csv"), col.names=TRUE, row.names=TRUE, sep='\t', quote=FALSE)

