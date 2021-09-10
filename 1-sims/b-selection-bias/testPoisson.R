

testPoisson <-function(s, x, dfC, resDir, filename) {


  ## calculate interaction between X and the covariates that affect S, including also each main effect
  model = glm(formula = s ~ x*(.), family = "poisson", data=dfC)
  sumx = summary(model)

  coefs = coef(sumx)
  coefNames = rownames(coefs)
  for (i in 1:length(coefNames)) {
    paramName = coefNames[i]
    beta = coefs[paramName, "Estimate"]
    se = coefs[paramName, "Std. Error"]
    p = coefs[paramName, "Pr(>|z|)"]
    resStr = paste(paramName, beta, se, p, sep=',')

    cat(resStr, file=paste0(resDir, filename), sep="\n", append=TRUE)
  }

}
