

##
## make grid of parameter combinations, for params corrs, or and ncs

params <- expand.grid(

	rCovars=c(-1,0,0.2,0.4,0.6,0.8),
	ncNotHP=c(1,5),
	ncHP=c(1,5),
	numSNPsHP = c(1),
	numSNPsNOTHP = c(1),
	hpEffect=c(0.001, 0.005, 0.01),
	ivEffect=c(0.05)
)




##
## get simulation results for each permutation of parameters

source('simStats.R')

resDir=Sys.getenv('RES_DIR')
resFile = paste0(resDir, '/sims/hp/sim-res.csv')


# generate summary stat for each param combination and save results to file
for (i in 1:nrow(params)) {

	res = simStats(params[i,])

	# write output file header line
	if (i == 1) {
		header = paste0(paste(colnames(params), collapse=','), ',', paste(names(res), collapse=','))
		print(header)
		cat(header, file=resFile, sep="\n", append=FALSE)
	}


	# write result to file
	resLine = cbind(params[i,], data.frame(res))	
	cat(paste(resLine, collapse=','), file=resFile, append=TRUE, sep='\n' )
}
