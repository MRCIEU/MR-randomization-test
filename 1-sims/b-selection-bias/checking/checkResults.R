
x = read.table('outXX.txt', header=1, sep=',')

print(paste0('corr0, ncs1', mean(x$rsq[which(x$ncs==1 & x$corr==0)])))
print(paste0('corr0, ncs3', mean(x$rsq[which(x$ncs==3 & x$corr==0)])))
print(paste0('corr0, ncs6', mean(x$rsq[which(x$ncs==6 & x$corr==0)])))
print(paste0('corr0, ncs9', mean(x$rsq[which(x$ncs==9 & x$corr==0)])))

print(paste0('corr0.2, ncs1', mean(x$rsq[which(x$ncs==1 & x$corr==0.2)])))
print(paste0('corr0.2, ncs3', mean(x$rsq[which(x$ncs==3 & x$corr==0.2)])))
print(paste0('corr0.2, ncs6', mean(x$rsq[which(x$ncs==6 & x$corr==0.2)])))
print(paste0('corr0.2, ncs9', mean(x$rsq[which(x$ncs==9 & x$corr==0.2)])))

