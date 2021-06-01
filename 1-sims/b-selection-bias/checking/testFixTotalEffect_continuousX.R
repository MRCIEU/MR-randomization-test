###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

sink('out-testFixTotalEffect_binaryX.txt')

plotHist=FALSE
source('../generateContinuousX.R')
source('../combineDeterminants.R')
library('MASS')




checkContinuousX <- function(zType, nc, ncs, corrC) {

  print(params)

  # number in sample
  n = 920000

  print(paste0('n=', n))
  print(paste0('zType: ', zType))
  print(paste0('nc: ', nc))

  for (i in 1:10) {

  ##
  ## generate covariates

  print('################')  
  print(paste0('Correlation: ', corrC, ', number of covars affecting selection:', ncs))

  print(class(corrC))

  ##
  ## generate covariates, instrument Z and exposure X
  
  corrCMat = diag(nc)
  corrCMat[which(corrCMat == 0)] = corrC
  dfC = mvrnorm(n=n, mu=rep(0, nc), Sigma=corrCMat, empirical=FALSE)
  dfC = as.data.frame(dfC)

  if(zType=="dosage") {
    z = sample(1:3, n, replace=TRUE, prob=c(0.64, 0.32, 0.04))
  } else {
    z = rnorm(n)
  }

  dataX = generateContinuousX(dfC, z, ncs)

  print(paste0('x: mean=', mean(dataX$x), ', sd=', sd(dataX$xy)))



  ##
  ## check rsq

  # rsq	using linear regression
  mylinear <- lm(dataX$x ~ z + ., data=dfC)
  sumx = summary(mylinear)
  rsq_x = sumx$r.squared
  print(paste0("Rsq x~z+covars: ", rsq_x))

  write(paste(i, zType, nc, ncs, corrC, rsq_x, sep=','), file='outXcont.txt', append=TRUE)

  }

}  



write('i,zType,nc,ncs,corr,rsq', file='outXcont.txt', append=FALSE)

params <- expand.grid(
  zType=c("grs", "dosage"),
  nc = c(10, 20),
  corrC = c(0,0.4,0.8),
  ncs=c(1,3,6,9)
)


apply(params, 1, function(x) checkContinuousX(zType=x['zType'], nc=as.numeric(x['nc']), ncs=as.numeric(x['ncs']), corrC=as.numeric(x['corrC'])))



sink()

