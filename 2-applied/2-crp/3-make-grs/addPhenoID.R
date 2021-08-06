

dataDir=Sys.getenv('PROJECT_DATA')
mydata = read.table(paste0(dataDir, '/genetic/crp-grs.csv'), header=1, sep=',')


linker = read.table(paste0(dataDir, '/genetic/ieu_id_linker.csv'), header=1, sep=',')


mydataWithPhenoIds = merge(mydata, linker, by.x = "pId", by.y = "appieu", all.x=F, all.y=F)


colnames(mydataWithPhenoIds)[which(colnames(mydataWithPhenoIds)=="app16729")] = "eid"


write.table(mydataWithPhenoIds, paste0(dataDir, '/genetic/crp-grs-with-phenoIDs.csv'), row.names=F,sep=',')



