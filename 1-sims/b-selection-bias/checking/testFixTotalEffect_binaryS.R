###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

source('../generateBinaryS.R')
source('../generateBinaryX.R')
source('../generateContinuousX.R')
source('../combineDeterminants.R')

library('MASS')



checkBinaryS <- function(zType, xType, nc, ncs, corrC, intendedrsq) {

  # number in sample
  n = 920000


  for (i in 1:10) {

  print('################')  
  print(paste0('Correlation: ', corrC, ', number of covars affecting selection:', ncs))


  ##
  ## generate covariates, instrument Z, exposure X and selection S
  
  corrCMat = diag(nc)
  corrCMat[which(corrCMat == 0)] = corrC
  dfC = mvrnorm(n=n, mu=rep(0, nc), Sigma=corrCMat, empirical=FALSE)
  dfC = as.data.frame(dfC)

  # generate z, then x using z, then s using CS and x
  if(zType=="dosage") {
    z = sample(1:3, n, replace=TRUE, prob=c(0.64, 0.32, 0.04))
  } else {
    z = rnorm(n)
  }

  if (xType=="binary") {
    dataX = generateBinaryX(dfC, z, ncs, corrC, n)
  }
  else {
    dataX = generateContinuousX(dfC, z, ncs)
  }

  dataS = generateBinaryS(dfC, dataX$x, ncs, intendedrsq, corrC)


  ##
  ## check distribution of variable X has probability case = 0.1

  propXCases = length(which(dataX$x==1))/n
  print(paste0('proportion of X cases: ', propXCases))


  ##
  ## check distribution of variable S has 10% selected

  propSelected = length(which(dataS$s==1))/n
  print(paste0('proportion selected: ', propSelected))


  ##
  ## check pseudo rsq

  mylinear <- lm(dataS$s ~ dataX$x + ., data=dfC[,1:ncs, drop=FALSE])
  rsq_s = rsq(mylinear)
  print(paste0('R sq: ', rsq_s))

  outfile = paste0('out/outS', gsub("\\.", "_", intendedrsq), '.txt')
  write(paste(i, zType, xType, nc, ncs, corrC, rsq_s, propSelected, sep=','), file=outfile, append=TRUE)
  
  }
  
}



args = commandArgs(trailingOnly=TRUE)
intendedrsq = args[1]
outfile = paste0('out/outS', gsub("\\.", "_", intendedrsq), '.txt')
print(outfile)


write('i,zType,xType,nc,ncs,corr,rsq,sProp', file=outfile, append=FALSE)

params <- expand.grid(
  zType=c("grs", "dosage"),
  xType=c("continuous", "binary"),
  nc = c(10, 20),
  corrC = c(0,0.4,0.8),
  ncs=c(1,3,6,9)
)


apply(params, 1, function(x) checkBinaryS(zType=x['zType'], nc=as.numeric(x['nc']), ncs=as.numeric(x['ncs']), corrC=as.numeric(x['corrC']), intendedrsq=intendedrsq, xType=x['xType']))



