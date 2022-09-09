


dataDir=Sys.getenv('PROJECT_DATA')

mydata = read.table(paste0(dataDir, '/genetic/crp-grs-with-phenoIDs.csv'), header=T, sep=',')

print(dim(mydata))

# exclude minimally relateds

print('Remove minimally related')

relateds = read.table(paste0(dataDir, '/genetic/data.minimal_relateds.qctools.txt'), header=F, sep=',')
relateds$related = TRUE

mydata = merge(mydata, relateds, by.x="pId", by.y="V1", all.x=T, all.y=FALSE)
mydata = mydata[which(is.na(mydata$related)),]

print(dim(mydata))


# keep only white british

print('Keep white british')

wb = read.table(paste0(dataDir, '/genetic/data.white_british.qctools.txt'), header=F, sep=',')

mydata = merge(mydata, wb, by.x="pId", by.y="V1", all.x=F, all.y=F)

print(dim(mydata))


# remove withdrawns

print('Remove withdrawns')

removals = read.table(paste0(dataDir, '/phenotypes/meta.withdrawn.20210809.csv'), header=F, sep=',')
removals$removed = TRUE

mydata = merge(mydata, removals, by.x="eid", by.y="V1", all.x=T, all.y=FALSE)
mydata = mydata[which(is.na(mydata$removed)),]

print(dim(mydata))

write.table(mydata, paste0(dataDir, '/genetic/crp-grs-with-phenoIDs-subset.csv'), row.names=FALSE, sep=',')





