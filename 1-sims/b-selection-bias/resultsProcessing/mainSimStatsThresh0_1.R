

##
## make grid of parameter combinations, for params corrs, or and ncs

params <- expand.grid(

	rCovars=c(-1,0,0.2,0.4,0.8),
	rSelection=c(0.05),
	ncNotS=c(2,10,50),
	ncs=c(2),
	ivEffect=c(0.05),
	iv=c('grs'),
	covarsIncluded=c('all'),
	allParticipants=c(0)
)



##
## get simulation results for each permutation of parameters

source('simStats.R')
source('loadResultsData.R')

resDir=Sys.getenv('RES_DIR')
resFile = paste0(resDir, '/sims/selection/sim-resFIX-thresh0_1.csv')

# write output file header line
cat(paste0(paste(colnames(params), collapse=','), ",numRes, powerBranson, mcseBranson, powerBon, mcseBon, powerInd, mcseInd, powerIndLi, mcseIndLi, powerRsq, mcseRsq"), file=resFile, sep="\n", append=FALSE)

# generate summary stat for each param combination and save results to file
for (i in 1:nrow(params)) {

	print(params)

	simRes = loadResultsData(params[i,])

	if (!is.null(simRes)) {
		res = simStats(simRes, pthreshold=0.1, numCovs=(params$ncs[i] + params$ncNotS[i]) )

		# write result to file
		resLine = cbind(params[i,], data.frame(res))	
		cat(paste(resLine, collapse=','), file=resFile, append=TRUE, sep='\n' )
	}
}


warnings()

