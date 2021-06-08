
combineDeterminants2 <- function(covars, otherdet, varExplCovars, varExplOtherDet) {

  n = nrow(covars)

    covC = cov(covars)
    pairWiseCov = covC[upper.tri(covC)]

    variances = sapply(covars, var)

    beta = sqrt(varExplCovars/(sum(variances) + 2*sum(pairWiseCov)))
  
  # total variance explained is 1 so variance explained by the error term is the remainder
  betaE = sqrt(1-(varExplCovars+varExplOtherDet))

  betaOtherDet = sqrt(varExplOtherDet)

  tmp = beta*rowSums(covars) + betaOtherDet*otherdet + betaE*rnorm(n, 0, 1)

  return(tmp)

}
