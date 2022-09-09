set.seed(1234)

n = 920000

diffCor = c()
diffReg = c()

for (i in 1:10) {

  # generate normally distributed covariate and IV
  covar = rnorm(n, 0, 1)
  z = rnorm(n, 0, 1)

  # correlation approach
  start_time <- Sys.time()
  meanDiff = cor(z, covar, use = "pairwise.complete.obs")*(sd(covar, na.rm=TRUE)/sd(z, na.rm=TRUE))
  end_time <- Sys.time()
  thisdiff = end_time - start_time
  diffCor = c(diffCor, thisdiff)

  # regression approach
  start_time <- Sys.time()
  fit = lm(z ~ covar)
  sumx = summary(fit)
  beta = sumx$coefficients["covar","Estimate"]
  end_time <- Sys.time()
  thisdiff = end_time - start_time 
  diffReg =  c(diffReg, thisdiff)

}

# calculate mean of each set of differences

print(mean(diffCor))
print(mean(diffReg))
