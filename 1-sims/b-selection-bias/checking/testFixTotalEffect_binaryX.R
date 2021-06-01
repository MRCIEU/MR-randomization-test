###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

sink('out-testFixTotalEffect_binaryX.txt')

plotHist=FALSE
source('../generateBinaryX.R')
source('../combineDeterminants.R')
library('MASS')




checkBinaryX <- function(zType, nc, ncs, corrC) {

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

  dataX = generateBinaryX(dfC, z, ncs, corrC, n)


  ##
  ## check distribution of variable X has probability case = 0.1

  propXCases = length(which(dataX$x==1))/n
  print(paste0('proportion of X cases: ', propXCases))


  ##
  ## check rsq and pseudo rsq


  # checking rsq=1 for variance explained 
#  mylinear <- lm(dataX$xCont ~ z + ., data=dfC)
#  sumx = summary(mylinear)
#  print(sumx$r.squared)

  # check rsq of x~xCont - if xCont is just a standard normal for all correlations then rsq should stay the same
  #mylinear <- lm(dataX$x ~ dataX$xCont)
  #sumx = summary(mylinear)
  #print(paste0("Rsq x~xCont: ", sumx$r.squared))


  # check mean(SD) of xCont stratified by X
  #print(paste0('x=1: mean=', mean(dataX$xCont[which(dataX$x==1)]), ', SD=', sd(dataX$xCont[which(dataX$x==1)])))
  #print(paste0('x=0: mean=', mean(dataX$xCont[which(dataX$x==0)]), ', SD=', sd(dataX$xCont[which(dataX$x==0)])))

  # plot distribution of xCont, all and stratified by X
  if (plotHist==TRUE) {
  pdf(paste0('xcont-', nc, '-', ncs, '-', corrC, '.pdf'))
  h1=hist(dataX$xCont, plot=FALSE, breaks=40)
  h2=hist(dataX$xCont[which(dataX$x==1)], plot=FALSE, breaks=40)
  h3=hist(dataX$xCont[which(dataX$x==0)], plot=FALSE, breaks=40)
  c1 <- rgb(173,216,230,max = 255, alpha = 50, names = "lt.blue")
  c2 <- rgb(255,192,203, max = 255, alpha = 50, names = "lt.pink")
  c3 <- rgb(180,255,200, max = 255, alpha = 50, names = "lt.green")
  plot(h1, col = c1)
  plot(h3, col = c3, add = TRUE)
  plot(h2, col = c2, add = TRUE)
  dev.off()
  }

  # check distribution of xCont, quantiles and Kolmogorov-Smirnov test of normality
  #print(quantile(dataX$xCont))
  #ks=ks.test(dataX$xCont, 'pnorm')
  #print(paste0('KS test for normality: ', ks$statistic, ', p=', ks$p.value))

  # rsq	using linear regression
  mylinear <- lm(dataX$x ~ z + ., data=dfC)
  sumx = summary(mylinear)
  rsq_x = sumx$r.squared
  print(paste0("Rsq x~x+covars: ", rsq_x))

  write(paste(i, zType, nc, ncs, corrC, rsq_x,propXCases, sep=','), file='outXX.txt', append=TRUE)

  }

}  



write('i,zType,nc,ncs,corr,rsq,xProp', file='outXX.txt', append=FALSE)

params <- expand.grid(
  zType=c("grs", "dosage"),
#  zType=c("grs"),
  nc = c(10, 20),
  corrC = c(0,0.4,0.8),
  ncs=c(1,3,6,9)
#  i=1:10
)


apply(params, 1, function(x) checkBinaryX(zType=x['zType'], nc=as.numeric(x['nc']), ncs=as.numeric(x['ncs']), corrC=as.numeric(x['corrC'])))



sink()

