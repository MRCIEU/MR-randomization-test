###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

source('../generateBinaryS.R')
source('../generateBinaryX.R')

library('MASS')

args = commandArgs(trailingOnly=TRUE)
pseudoR2 = args[1]
outfile = paste0('outS', gsub("\\.", "_", pseudoR2), '.txt')
print(outfile)

# number in sample
n = 920000

write('i,ncs,corr,rsq', file=outfile, append=FALSE)

# number of covariates
for (nc in c(20, 10)) {

for (corrC in c(0, 0.2)) {

for (ncs in c(1,3,6,9)) {

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
  z = sample(1:3, n, replace=TRUE, prob=c(0.64, 0.32, 0.04))
  dataX = generateBinaryX(dfC, z, ncs, corrC)
  dataS = generateBinaryS(dfC, dataX$x, ncs, pseudoR2, corrC)

  ##
  ## check distribution of variable X has probability case = 0.1

  propXCases = length(which(dataX$x==1))/n
  print(paste0('proportion of X cases: ', propXCases))




  ##
  ## check distribution of variable S has 10% selected

  propXCases = length(which(dataX$x==1))/n
  print(paste0('proportion of X cases: ', propXCases))

  propSelected = length(which(dataS$s==1))/n
  print(paste0('proportion selected: ', propSelected))


  ##
  ## check pseudo rsq

  mylogit <- glm(dataS$s ~ dataX$x + ., data=dfC[,1:ncs, drop=FALSE], family="binomial")
  rsq_s = rsq(mylogit)
  print(paste0('pseudo R sq: ', rsq_s))


  write(paste(i, ncs, corrC, rsq_s, sep=','), file=outfile, append=TRUE)
}
  
}
}

}
