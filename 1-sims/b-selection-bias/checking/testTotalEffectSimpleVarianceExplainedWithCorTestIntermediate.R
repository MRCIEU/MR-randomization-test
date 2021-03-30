###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

source('generateY.R')

library('MASS')

# number in sample
n = 350000
  
# number of covariates
nc = 20


#for (corrC in c(0.1,0.3,0.6,0.9)) {
for (corrC in c(0, 0.1)) {

print('#############################')
print(paste0('Correlation: ', corrC))

##
## generate covariates

corrCMat = diag(nc)
corrCMat[which(corrCMat == 0)] = corrC
dfC = mvrnorm(n=n, mu=rep(0, nc), Sigma=corrCMat, empirical=FALSE)
dfC = as.data.frame(dfC)

  
for (ncs in 1:9) {

  print('################')  
  print(paste0('number of covars affecting selection:', ncs))
      
  y = generateY(dfC, null, ncs)
  
}


}
