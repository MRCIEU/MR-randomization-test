
# covars: dependent covars
# otherdet: another determinant but one that is independent of the others
combineDeterminants2 <- function(covars, otherdet, varExplCovars, varExplOtherDet) {

  n = nrow(covars)

    covC = cov(covars)
    pairWiseCov = covC[upper.tri(covC)]

    variances = sapply(covars, var)

    beta = sqrt(varExplCovars/(sum(variances) + 2*sum(pairWiseCov)))
  
  # total variance explained is 1 so variance explained by the error term is the remainder
  betaE = sqrt(1-(varExplCovars+varExplOtherDet))

  betaOtherDet = sqrt(varExplOtherDet/var(otherdet))

  tmp = beta*rowSums(covars) + betaOtherDet*otherdet + betaE*rnorm(n, 0, 1)

  return(tmp)

}

# det1 and det2 are two determinants each explaining a certain proportion of the variance
combineDeterminants3 <- function(det1, det2, varExplDet1, varExplDet2) {


  pairWiseCov = cov(det1,det2)
  var1 = var(det1)
  var2 = var(det2)

  # total variance explained
  T = varExplDet1 + varExplDet2
  print(paste0('T: ', T))

  beta = sqrt(T/(var1+var2 + 2*pairWiseCov))

  # total variance explained is 1 so variance explained by the error term is the remainder
  betaE = sqrt(1-T)

  n = length(det1)
  tmp = beta*det1 + beta*det2 + betaE*rnorm(n, 0, 1)

  return(tmp)

}
