
generateIV <- function(ivType, n, numSnps=1) {


  if(ivType == "dosage") {

    i=0
    while (i<numSnps) {

      ## generate a IV with 3 categories

      ## use p(A1)=0.8, p(A2)=0.2, dosage probs assuming HWE = (0.8^2, 2*0.8*0.2, 0.2^2) = (0.64,0.32,0.04)
      print(paste0('generate dosage IV ',i))

      thisz = sample(1:3, n, replace=TRUE, prob=c(0.64, 0.32, 0.04))

      if (i == 0) {
        z = data.frame(z1 = thisz)
      }
      else {
        z = cbind(z, thisz)
        colnames(z)[i+1] = paste0('z',i+1)
      }

      i = i + 1
    }

    return(z)


  } else if (ivType=="grs") {

    print('generate grs IV')
    z = rnorm(n)

    return(z)

  }
  else {
    stop("ivType not grs or dosage")
  }

  return(NULL)

}
