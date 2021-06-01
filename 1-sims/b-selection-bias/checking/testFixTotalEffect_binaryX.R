###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

sink('out-testFixTotalEffect_binaryX.txt')

source('../generateBinaryX.R')
source('../combineDeterminants.R')

library('MASS')

# number in sample
n = 920000
print(paste0('n=', n)) 

write('i,nc, ncs,corr,rsq', file='outXX.txt', append=FALSE)

# number of covariates
for (nc in c(10, 20)) {

print(paste0('nc: ', nc))

for (corrC in c(0, 0.4, 0.8)) {

##
## generate covariates

  
for (ncs in c(1,3,6,9)) {

  for (i in 1:10) {

  print('################')  
  print(paste0('Correlation: ', corrC, ', number of covars affecting selection:', ncs))

  ##
  ## generate covariates, instrument Z and exposure X
  
  corrCMat = diag(nc)
  corrCMat[which(corrCMat == 0)] = corrC
  dfC = mvrnorm(n=n, mu=rep(0, nc), Sigma=corrCMat, empirical=FALSE)
  dfC = as.data.frame(dfC)

  z = sample(1:3, n, replace=TRUE, prob=c(0.64, 0.32, 0.04))

  dataX = generateBinaryX(dfC, z, ncs, corrC)


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
  mylinear <- lm(dataX$x ~ dataX$xCont)
  sumx = summary(mylinear)
  print(paste0("Rsq x~xCont: ", sumx$r.squared))

  # check mean(SD) of xCont stratified by X
  print(paste0('x=1: mean=', mean(dataX$xCont[which(dataX$x==1)]), ', SD=', sd(dataX$xCont[which(dataX$x==1)])))
  print(paste0('x=0: mean=', mean(dataX$xCont[which(dataX$x==0)]), ', SD=', sd(dataX$xCont[which(dataX$x==0)])))

  # plot distribution of xCont, all and stratified by X
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

  # check distribution of xCont, quantiles and Kolmogorov-Smirnov test of normality
  print(quantile(dataX$xCont))
  ks=ks.test(dataX$xCont, 'pnorm')
  print(paste0('KS test for normality: ', ks$statistic, ', p=', ks$p.value))

#  write.csv(data.frame(xcont=dataX$xCont, x=dataX$x), paste0('xcont-', nc, '-', ncs, '-', corrC, '.csv'))

  # rsq	using linear regression
  mylinear <- lm(dataX$x ~ z + ., data=dfC)
  sumx = summary(mylinear)
  print(paste0("Rsq x~x+covars: ", sumx$r.squared))

  # get pseudo rsq of binary x, with covariates and z
  #mylogit <- glm(dataX$x ~ z + dataX$tmpCS+ dataX$tmpCNOTS, family="binomial")
  mylogit <- glm(dataX$x ~ z + ., data=dfC, family="binomial")
  rsq_x = rsq(mylogit)
  print(paste0('pseudo R sq x~x+covars: ', rsq_x))
  write(paste(i, nc, ncs, corrC, rsq_x, sep=','), file='outXX.txt', append=TRUE)

}  

}

}
}

sink()

