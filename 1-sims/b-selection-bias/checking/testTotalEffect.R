

# test approach to fix total effect of covariates on a continuous outcome y and a binary outcome x

resDir=Sys.getenv('RES_DIR')

# rsq package for calculating rsq for binary outcome
library('rsq')

source('../generateSimData.R')

outfile = paste0(resDir, '/sims/testTotalEffect.csv')
cat('ncs,i,rsq_cs_y,rsq_cnots_y,rsq_cs_x,rsq_cnots_x,rsq_cs_x_brok\n', file=outfile, append=FALSE)

n=450000
nc=15

# generate data for different ncs values to compare if rsq value is similar
for (ncs in 1:4) {

  print(ncs)

  # try each ncs value 100 times to get a distribution
  for (i in 1:100) {
    simdata = generateSimData(n=n, nc=nc, ncs=ncs, corrC=0, totalEffectCovarsSelection=2)


    # get rsq for continuous outcome
    sumx = summary(lm(simdata$y ~ ., data=simdata$dfC[,1:ncs, drop=FALSE]))
    rsq_cs_y = sumx$r.squared
    adjrsq_cs_y = sumx$adj.r.squared

    sumx = summary(lm(simdata$y ~ ., data=simdata$dfC[,(ncs+1):nc, drop=FALSE]))
    rsq_cnots_y = sumx$r.squared
    adjrsq_cnots_y = sumx$adj.r.squared




    # get rsq for binary outcome
    mylogit <- glm(simdata$x ~ ., data=simdata$dfC[,1:ncs, drop=FALSE], family="binomial")
    rsq_cs_x = rsq(mylogit)

    mylogit <- glm(simdata$x ~ ., data=simdata$dfC[,(ncs+1):nc, drop=FALSE], family="binomial")
    rsq_cnots_x = rsq(mylogit)


    ###
    ### broken example to show rsq are different if we calc betas incorrectly

    betaCs_onX = 2/ncs
    betaCnots_onX = 2/(nc-ncs)

    # generate exposure x with incorrect betas
    # rsq for this should differ acros ncs
    logitPart = simdata$z + rowSums(betaCs_onX*simdata$dfC[,1:ncs, drop=FALSE]) + rowSums(betaCnots_onX*simdata$dfC[,(ncs+1):nc, drop=FALSE])
    pX = exp(logitPart)/(1+exp(logitPart))
    xBrok = rep(0, 1, length(simdata$z))
    xBrok[runif(length(simdata$z)) <= pX] = 1


    mylogit <- glm(xBrok ~ ., data=simdata$dfC[,1:ncs, drop=FALSE], family="binomial")
    rsq_cs_x_brok = rsq(mylogit)
    print(rsq_cs_x_brok)


    ## write to file
    cat(paste0(ncs, ',', i, ',', rsq_cs_y, ',', rsq_cnots_y, ',', rsq_cs_x, ',', rsq_cnots_x, ',', rsq_cs_x_brok, '\n'), file=outfile, append=TRUE)


    }

}






