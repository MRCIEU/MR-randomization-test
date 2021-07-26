


getMD3Cats <- function(covars, z, covX.inv) {

	# mean difference across three ordinal categories - treat as continuous
	meanDiffs = rep(NA,ncol(covars))
	for (i in 1: ncol(covars)) {
		covar = covars[,i]
		fit = lm(z ~ covar)
		sumx = summary(fit)
		beta = sumx$coefficients["covar","Estimate"]
		meanDiffs[i] = beta
	}

	md = t(meanDiffs) %*% covX.inv %*% meanDiffs

	return(md)

}


getMD3CatsCorr <- function(covars, z, covX.inv) {

	# mean difference across three ordinal categories - treat as continuous
	meanDiffs = rep(NA,ncol(covars))
	for (i in 1: ncol(covars)) {
		covar = covars[,i]

		meanDiffs[i] = cor(z, covar)*(sd(covar)/sd(z))
	}

	md = t(meanDiffs) %*% covX.inv %*% meanDiffs

	return(md)

}

