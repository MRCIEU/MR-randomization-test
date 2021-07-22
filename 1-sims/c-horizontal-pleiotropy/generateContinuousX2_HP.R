###
### Testing fixing the total effect of the set of covariates cs	(that are affected by HP snps) and c_not_hp (that are not affected by HP snps) on a continuous outcome y
###
### This version splits the beta coefficients between the covariates and generates intermediate variables, that are then used to generate y

# use MASS for mvrnorm
library('MASS')


generateContinuousX2_HP <- function(dfC, z, ncHP, numHPSnps, ivRsq=0.1) {


  # number of covariates
  nc = ncol(dfC)
  n = nrow(dfC)
  ncnotHP = nc - ncHP


  if (ncHP>0 & ncnotHP>0) {
    print('generating X using Z, CHP and CnotHP')

    ## generate intermediate variables for covariates
    # combine the variables in CS and CNOTS INTO COMBINED VARIABLES, RESPECTIVELY.
    tmpCS = rowSums(dfC[,1:ncHP, drop=FALSE]) 
    tmpCNOTS = rowSums(dfC[,(ncHP+1):nc, drop=FALSE]) 

    # doesn't matter that they have different variance because we account for their variance in the next step
    print(paste0('tmpCS intermed: mean=', mean(tmpCS), ', sd=', sd(tmpCS)))
    print(paste0('tmpCNOTS intermed: mean=', mean(tmpCNOTS), ', sd=', sd(tmpCNOTS)))


    if (numHPSnps<ncol(z)) {
    ## generate intermediate variable for nonHP SNPs (at indexes (numHPSnps+1):ncol(z) in z)
    tmpZ = rowSums(z[,(numHPSnps+1):ncol(z), drop=FALSE])

    ## continuous exposure X
    x = combineDeterminants2(covars=data.frame(tmpCS=tmpCS, tmpCNOTS=tmpCNOTS), otherdet=tmpZ, varExplOtherDet=ivRsq, varExplCovars=0.1)
    }
    else {

       x = combineDeterminants3(tmpCS, tmpCNOTS, 0.05, 0.05)
    }


  }
  else if (ncHP>0 & ncnotHP==0) {

    print('generating X using Z, CHP')

    tmpCNOTS = NULL
    tmpCS = rowSums(dfC[,1:ncHP, drop=FALSE])
    print(paste0('tmpCS intermed: mean=', mean(tmpCS), ', sd=', sd(tmpCS)))

    ## generate	intermediate variable for nonHP SNPs (at indexes (numHPSnps+1):ncol(z) in z)
    tmpZ = rowSums(z[,(numHPSnps+1):ncol(z), drop=FALSE])

    ## continuous exposure X
    x = combineDeterminants3(tmpZ, tmpCS, ivRsq, 0.1)

  }
  else if (ncHP==0 & ncnotHP>0) {

    print('generating X using Z, CSnotHP')

    tmpCS = NULL
    tmpCNOTS = rowSums(dfC[,(ncHP+1):nc, drop=FALSE])
    print(paste0('tmpCNOTS intermed: mean=', mean(tmpCNOTS), ', sd=', sd(tmpCNOTS)))

    ## generate	intermediate variable for nonHP SNPs (at indexes (numHPSnps+1):ncol(z) in z)
    tmpZ = rowSums(z[,(numHPSnps+1):ncol(z), drop=FALSE])

    ## continuous exposure X
    x = combineDeterminants3(tmpZ, tmpCNOTS, ivRsq, 0.1)

  }



  return(list(x=x, tmpCS=tmpCS, tmpCNOTS=tmpCNOTS))

}
