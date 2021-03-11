
# version of MD calculation using regression with z as the exposure
getMDTest <- function(covars, z, covX.inv) {

	# mean difference across three ordinal categories - treat as continuous
	meanDiffs = rep(NA,ncol(covars))
	for (i in 1: ncol(covars)) {
		covar = covars[,i]
		fit = lm(covar ~ z)
		sumx = summary(fit)
		beta = sumx$coefficients["z","Estimate"]
		meanDiffs[i] = beta
	}

	md = t(meanDiffs) %*% covX.inv %*% meanDiffs

	return(md)

}

