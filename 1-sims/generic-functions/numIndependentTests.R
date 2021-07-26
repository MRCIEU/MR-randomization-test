
## this code is adapted from code included in PhenoSpD written by Jie Zheng (https://github.com/MRCIEU/PhenoSpD/blob/master/script/SpD.r)
## GNU General Public License v3

numIndependentTests <- function(phenocorr) {

print('numIndependentTests start')

## Read in correlation matrix:    
# Set NA value as 0 to run the SpD analysis
phenocorr[is.na(phenocorr)] <- 0

# For multiple test correction the sign of the correlation is irrelevant (i.e., so we're best to input absolute values)
corr.matrix<-abs(phenocorr)  

## Remove Duplicate Columns:
corr.matrix.RemoveDupCol <- corr.matrix[!duplicated((corr.matrix))]

## Remove Duplicate Rows:
corr.matrix.RemoveDupRow <- unique((corr.matrix.RemoveDupCol))

## Remove Redundant VAR Names:
VARnames.NonRedundant<-as.matrix(dimnames(corr.matrix.RemoveDupCol)[[2]])
colnames(VARnames.NonRedundant)<-"VAR"

evals<-eigen(t(corr.matrix.RemoveDupRow),symmetric=T)$values

oldV<-var(evals)
M<-length(evals)
L<-(M-1)
Meffold<-M*(1-(L*oldV/M^2))

if (M == 1) { 
  oldV <- 0 
  Meffold <- M
}

labelevals<-array(dim=M)
for(col in 1:M) { labelevals[col]<-c(col) }
levals<-cbind(labelevals, evals)

newevals<-evals
for(i in 1:length(newevals)) { 
  if(newevals[i] < 0) { 
    newevals[i] <- 0
  }
}

newlevals<-cbind(labelevals, newevals)

newV<-var(newevals)

# https://www.nature.com/articles/6889010
# MEFF = M_eff the effective number of independent traits
Meffnew<-M*(1-(L*newV/M^2))

if (M == 1) { 
  newV <- 0 
  Meffnew <- M
}


##############################################################################################################################################

## Implement improved approach of Li and Ji. Heredity 2005 95:221-227

IntLinewevals<-newevals

for(i in 1:length(IntLinewevals)) {
  if(IntLinewevals[i] >= 1 ) {
    IntLinewevals[i] <- 1
  }
  if(IntLinewevals[i] < 1 ) {
    IntLinewevals[i] <- 0
  }
}

NonIntLinewevals <- newevals-floor(newevals)

MeffLi <- sum(NonIntLinewevals+IntLinewevals)




return(list(indepLi=MeffLi, indepMain=Meffnew))

}
