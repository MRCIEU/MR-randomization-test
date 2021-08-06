


dataDir=Sys.getenv('PROJECT_DATA')

mydata = read.table(paste0(dataDir, '/genetic/crp-grs-with-phenoIDs.csv'), header=T, sep=',')


# exclude minimally relateds

relateds = read.table(paste0(dataDir, '/genetic/data.minimal_relateds.qctools.txt'), header=F, sep=',')
relateds$related = TRUE

mydata = merge(mydata, relateds, by.x="pId", by.y="V1", all.x=T, all.y=FALSE)
mydata = mydata[which(is.na(mydata$related)),]


# keep only white british

wb = read.table(paste0(dataDir, '/genetic/data.white_british.qctools.txt'), header=F, sep=',')

mydata = merge(mydata, wb, by.x="pId", by.y="V1", all.x=F, all.y=F)



write.table(mydata, paste0(dataDir, '/genetic/crp-grs-with-phenoIDs-subset.csv'), row.names=FALSE, sep=',')





