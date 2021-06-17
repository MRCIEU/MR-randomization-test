###
### Testing fixing the total effect of the set of covariates cs	(that affect selection)	and c_nots (that don't affect selection) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

# use MASS for mvrnorm
library('MASS')


generateContinuousX2 <- function(dfC, z, ncs, ivRsq=0.1) {


  # number of covariates
  nc = ncol(dfC)
  n = nrow(dfC)

  ##
  ## generate intermediate outcomes

  # combine the variables in CS and CNOTS INTO COMBINED VARIABLES, RESPECTIVELY.
  tmpCS = rowSums(dfC[,1:ncs, drop=FALSE]) 
  tmpCNOTS = rowSums(dfC[,(ncs+1):nc, drop=FALSE]) 

  # doesn't matter that they have different variance because we account for their variance in the next step
  print(paste0('tmpCS intermed: mean=', mean(tmpCS), ', sd=', sd(tmpCS)))
  print(paste0('tmpCNOTS intermed: mean=', mean(tmpCNOTS), ', sd=', sd(tmpCNOTS)))


  ##
  ## continuous outcome y

  x = combineDeterminants2(covars=data.frame(tmpCS=tmpCS, tmpCNOTS=tmpCNOTS), otherdet=z, varExplOtherDet=ivRsq, varExplCovars=0.1)

  return(list(x=x, tmpCS=tmpCS, tmpCNOTS=tmpCNOTS))

}
