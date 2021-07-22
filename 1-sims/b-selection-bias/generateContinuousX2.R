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
  ncnots = nc - ncs


  if (ncs>0 & ncnots>0) {
    print('generating X using Z, CS and CnotS')

    ## generate intermediate outcomes
    # combine the variables in CS and CNOTS INTO COMBINED VARIABLES, RESPECTIVELY.
    tmpCS = rowSums(dfC[,1:ncs, drop=FALSE]) 
    tmpCNOTS = rowSums(dfC[,(ncs+1):nc, drop=FALSE]) 

    # doesn't matter that they have different variance because we account for their variance in the next step
    print(paste0('tmpCS intermed: mean=', mean(tmpCS), ', sd=', sd(tmpCS)))
    print(paste0('tmpCNOTS intermed: mean=', mean(tmpCNOTS), ', sd=', sd(tmpCNOTS)))


    ## continuous exposure X

    x = combineDeterminants2(covars=data.frame(tmpCS=tmpCS, tmpCNOTS=tmpCNOTS), otherdet=z, varExplOtherDet=ivRsq, varExplCovars=0.1)

  }
  else if (ncs>0 & ncnots==0) {

    print('generating X using Z, CS')

    tmpCNOTS = NULL
    tmpCS = rowSums(dfC[,1:ncs, drop=FALSE])
    print(paste0('tmpCS intermed: mean=', mean(tmpCS), ', sd=', sd(tmpCS)))

    ## continuous exposure X
    x = combineDeterminants3(z, tmpCS, ivRsq, 0.1)

  }
  else if (ncs==0 & ncnots>0) {

    print('generating X using Z, CSnotS')

    tmpCS = NULL
    tmpCNOTS = rowSums(dfC[,(ncs+1):nc, drop=FALSE])
    print(paste0('tmpCNOTS intermed: mean=', mean(tmpCNOTS), ', sd=', sd(tmpCNOTS)))

    ## continuous exposure X
    x = combineDeterminants3(z, tmpCNOTS, ivRsq, 0.1)

  }



  return(list(x=x, tmpCS=tmpCS, tmpCNOTS=tmpCNOTS))

}
