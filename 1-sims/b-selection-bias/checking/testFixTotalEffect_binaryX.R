###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

sink('out-testFixTotalEffect_binaryX.txt')

source('../generateBinaryX.R')

library('MASS')

# number in sample
n = 920000
  
# number of covariates
nc = 20


for (corrC in c(0, 0.1)) {


##
## generate covariates

  
for (ncs in c(1,3,6,9)) {

  print('################')  
  print(paste0('Correlation: ', corrC, ', number of covars affecting selection:', ncs))

  ##
  ## generate covariates, instrument Z and exposure X
  
  corrCMat = diag(nc)
  corrCMat[which(corrCMat == 0)] = corrC
  dfC = mvrnorm(n=n, mu=rep(0, nc), Sigma=corrCMat, empirical=FALSE)
  dfC = as.data.frame(dfC)

  z = sample(1:3, n, replace=TRUE, prob=c(0.64, 0.32, 0.04))

  dataX = generateBinaryX(dfC, z, ncs)


  ##
  ## check distribution of variable X has probability case = 0.1

  propXCases = length(which(dataX$x==1))/n
  print(paste0('proportion of X cases: ', propXCases))


  ##
  ## check pseudo rsq

  print("MODEL WITH THE TWO INTERMEDIATE VARIABLES")
  mylogit <- glm(dataX$x ~ z + dataX$tmpCS + dataX$tmpCNOTS, family="binomial")
  rsq_x = rsq(mylogit)
  print(paste0('pseudo R sq of 2 intermediate variables on x: ', rsq_x))

  
}


}

sink()

