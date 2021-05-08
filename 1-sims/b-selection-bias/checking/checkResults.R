
printmeans <- function(x) {
  print(paste0('corr0, ncs1: ',format(round(mean(x$rsq[which(x$ncs==1 & x$corr==0)]), 4), nsmall=4)))
  print(paste0('corr0, ncs3: ', format(round(mean(x$rsq[which(x$ncs==3 & x$corr==0)]), 4), nsmall=4)))
  print(paste0('corr0, ncs6: ', format(round(mean(x$rsq[which(x$ncs==6 & x$corr==0)]), 4), nsmall=4)))
  print(paste0('corr0, ncs9: ', format(round(mean(x$rsq[which(x$ncs==9 & x$corr==0)]), 4), nsmall=4)))

  print(paste0('corr0.2, ncs1: ', format(round(mean(x$rsq[which(x$ncs==1 & x$corr==0.2)]), 4), nsmall=4)))
  print(paste0('corr0.2, ncs3: ', format(round(mean(x$rsq[which(x$ncs==3 & x$corr==0.2)]), 4), nsmall=4)))
  print(paste0('corr0.2, ncs6: ', format(round(mean(x$rsq[which(x$ncs==6 & x$corr==0.2)]), 4), nsmall=4)))
  print(paste0('corr0.2, ncs9: ', format(round(mean(x$rsq[which(x$ncs==9 & x$corr==0.2)]), 4), nsmall=4)))
}

## Binary X

print('** Binary X **')
x = read.table('outXX.txt', header=1, sep=',')
printmeans(x)


## Continuous Y

print('** Continuous Y **')
x = read.table('outY.txt', header=1, sep=',')
printmeans(x)


## Binary S

print('** Binary S 0.2 **')
x = read.table('outS0_2.txt', header=1, sep=',')
printmeans(x)

print('** Binary S 0.4 **')
x = read.table('outS0_4.txt', header=1, sep=',')
printmeans(x)

print('** Binary S 0.6 **')
x = read.table('outS0_6.txt', header=1, sep=',')
printmeans(x)






