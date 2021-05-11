
printOne <- function(x, nc, ncs, corr) {
  print(paste0('corr',corr,', nc',nc,', ncs',ncs,': mean=',format(round(mean(x$rsq[which(x$nc==nc & x$ncs==ncs & x$corr==corr)]), 4), nsmall=4), ', sd=', format(round(sd(x$rsq[which(x$nc==nc & x$ncs==ncs & x$corr==corr)]), 4), nsmall=4)))
}


printmeans <- function(x) {

  printOne(x, 20, 1, 0)
  printOne(x, 20, 3, 0)
  printOne(x, 20, 6, 0)
  printOne(x, 20, 9, 0)
  printOne(x, 20, 1, 0.4)
  printOne(x, 20, 3, 0.4)
  printOne(x, 20, 6, 0.4)
  printOne(x, 20, 9, 0.4)
  printOne(x, 20, 1, 0.8)
  printOne(x, 20, 3, 0.8)
  printOne(x, 20, 6, 0.8)
  printOne(x, 20, 9, 0.8)

  printOne(x, 10, 1, 0)
  printOne(x, 10, 3, 0)
  printOne(x, 10, 6, 0)
  printOne(x, 10, 9, 0)
  printOne(x, 10, 1, 0.4)
  printOne(x, 10, 3, 0.4)
  printOne(x, 10, 6, 0.4)
  printOne(x, 10, 9, 0.4)
  printOne(x, 10, 1, 0.8)
  printOne(x, 10, 3, 0.8)
  printOne(x, 10, 6, 0.8)
  printOne(x, 10, 9, 0.8)
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






