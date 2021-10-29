

##
## make grid of parameter combinations, for params corrs, or and ncs

params <- expand.grid(

	rCovars=c(-1,0,0.2,0.4),
	ncNotHP=c(1,5),
	ncHP=c(1,5),
	numSNPsHP = c(1,10),
	numSNPsNOTHP = c(1,10,50),
	ivEffect=c(0.05)
)



##
## get simulation results for each permutation of parameters

source('simStats.R')

resDir=Sys.getenv('RES_DIR')
resFile = paste0(resDir, '/sims/hp/sim-res.csv')

# write output file header line
cat(paste0(paste(colnames(params), collapse=','), ",numRes, powerBranson, mcseBranson, powerBon, mcseBon, powerInd, mcseInd, powerIndLi, mcseIndLi,powerBranPerSnp, mcseBranPerSnp, powerBonfPerSnp, mcseBonfPerSnp, powerIndMPerSnp, mcseIndMPerSnp, powerIndLPerSnp, mcseIndLPerSnp"), file=resFile, sep="\n", append=FALSE)

# generate summary stat for each param combination and save results to file
for (i in 1:nrow(params)) {

	res = simStats(params[i,])

	# write result to file
	resLine = cbind(params[i,], data.frame(res))	
	cat(paste(resLine, collapse=','), file=resFile, append=TRUE, sep='\n' )
}
