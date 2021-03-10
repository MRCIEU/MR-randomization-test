

##
## make grid of parameter combinations, for params corrs, or and ncs

params <- expand.grid(

	corrs=c(0,0.1,0.2,0.4,0.8),
	or=c(2),
	ncs=c(10,50)
)

##
## add nc_nots settings, that are relative to ncs number

# {0, ncs/2, ncs, 2*ncs}
numParams = nrow(params)

# replicate so 4 versions of params for each nc_nots value
params = rbind(params, params, params, params, params)

# set nc_nots values for each nc_nots set of params
params$ncNOTs[1:numParams] = 1
params$ncNOTs[(numParams+1):(2*numParams)] = params$ncs[(numParams+1):(2*numParams)]/2
params$ncNOTs[(2*numParams+1):(3*numParams)] = params$ncs[(2*numParams+1):(3*numParams)]
params$ncNOTs[(3*numParams+1):(4*numParams)] = 2*params$ncs[(3*numParams+1):(4*numParams)]
params$ncNOTs[(4*numParams+1):(5*numParams)] = 4*params$ncs[(4*numParams+1):(5*numParams)]



##
## get simulation results for each permutation of parameters

source('simStats.R')

resDir=Sys.getenv('RES_DIR')
resFile = paste0(resDir, '/sims/sim-res.csv')

# write output file header line
cat(paste0(paste(colnames(params), collapse=','), ",numRes, powerBranson, mcseBranson, powerBon, mcseBon"), file=resFile, sep="\n", append=FALSE)

# generate summary stat for each param combination and save results to file
for (i in 1:nrow(params)) {

	res = simStats(params[i,])

	# write result to file
	resLine = cbind(params[i,], data.frame(res))	
	cat(paste(resLine, collapse=','), file=resFile, append=TRUE, sep='\n' )
}
