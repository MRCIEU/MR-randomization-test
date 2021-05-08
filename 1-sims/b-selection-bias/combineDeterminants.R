
combineDeterminants <- function(determinants) {


  if (ncol(determinants) == 1) {
     beta = 1
  }
  else {
    covC = cov(determinants)
    pairWiseCov = covC[upper.tri(covC)]

    variances = sapply(determinants, var)

    beta = sqrt(1/(sum(variances) + 2*sum(pairWiseCov)))
  }
  

  tmp = beta*rowSums(determinants)

  return(tmp)

}
