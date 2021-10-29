

##
## make grid of parameter combinations, for params corrs, or and ncs


# versions with no selection i.e. all participants included
params <- expand.grid(

        rCovars=c(-1,0,0.2,0.4,0.8),
        rSelection=c(0.05, 0.1, 0.2),
        ncNotS=c(2,10,50),
        ncs=c(2,10,50),
        ivEffect=c(0.05),
        iv=c('grs'),
        covarsIncluded=c('all'),
        allParticipants=c(1)
)



##
## get simulation results for each permutation of parameters

source('simStats.R')
source('loadResultsData.R')

resDir=Sys.getenv('RES_DIR')
resFile = paste0(resDir, '/sims/selection/sim-res-allparticipants.csv')

# write output file header line
cat(paste0(paste(colnames(params), collapse=','), ",numRes, powerBranson, mcseBranson, powerBon, mcseBon, powerInd, mcseInd, powerIndLi, mcseIndLi, powerRsq, mcseRsq"), file=resFile, sep="\n", append=FALSE)

# generate summary stat for each param combination and save results to file
for (i in 1:nrow(params)) {

	simRes = loadResultsData(params[i,])
        res = simStats(simRes)

	# write result to file
	resLine = cbind(params[i,], data.frame(res))	
	cat(paste(resLine, collapse=','), file=resFile, append=TRUE, sep='\n' )
}


warnings()


