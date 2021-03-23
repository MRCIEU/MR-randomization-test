
resDir=Sys.getenv('RES_DIR')


res = read.table(paste0(resDir, '/sims/testTotalEffect.csv'), sep=',', header=1)


summary(res[which(res$ncs==1),])
summary(res[which(res$ncs==2),])
summary(res[which(res$ncs==3),])
summary(res[which(res$ncs==4),])

