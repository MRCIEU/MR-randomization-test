
combineDeterminants <- function(determinants, varExpl=1) {

  n = nrow(determinants)

  if (ncol(determinants) == 1) {
     beta = 1
  }
  else {
    covC = cov(determinants)
    pairWiseCov = covC[upper.tri(covC)]

    variances = sapply(determinants, var)

    beta = sqrt(varExpl/(sum(variances) + 2*sum(pairWiseCov)))
  }
  
  # total variance explained is 1 so variance explained by the error term is the remainder
  betaE = sqrt((1-varExpl))

  tmp = beta*rowSums(determinants) + betaE*rnorm(n, 0, 1)

  return(tmp)

}
