

##
## make grid of parameter combinations, for params corrs, or and ncs

params <- expand.grid(

	rCovars=c(0,0.4,0.8),
	rSelection=c(0.1, 0.2),
	ncNotS=c(2,10,50),
	ncs=c(2,10,50)
)



##
## get simulation results for each permutation of parameters

source('simStats.R')

resDir=Sys.getenv('RES_DIR')
resFile = paste0(resDir, '/sims/sim-res.csv')

# write output file header line
cat(paste0(paste(colnames(params), collapse=','), ",numRes, powerBranson, mcseBranson, powerBon, mcseBon, powerInd, mcseInd"), file=resFile, sep="\n", append=FALSE)

# generate summary stat for each param combination and save results to file
for (i in 1:nrow(params)) {

	res = simStats(params[i,])

	# write result to file
	resLine = cbind(params[i,], data.frame(res))	
	cat(paste(resLine, collapse=','), file=resFile, append=TRUE, sep='\n' )
}
