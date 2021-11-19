

genCAD <- function(phenos) {


## get phenos

phenos$cad = 0

phenos$cad[which(phenos$x131296_0_0!="")] = 1
phenos$cad[which(phenos$x131297_0_0!="")] = 1
phenos$cad[which(phenos$x131298_0_0!="")] = 1
phenos$cad[which(phenos$x131299_0_0!="")] = 1
phenos$cad[which(phenos$x131300_0_0!="")] = 1
phenos$cad[which(phenos$x131301_0_0!="")] = 1
phenos$cad[which(phenos$x131302_0_0!="")] = 1
phenos$cad[which(phenos$x131303_0_0!="")] = 1
phenos$cad[which(phenos$x131304_0_0!="")] = 1
phenos$cad[which(phenos$x131305_0_0!="")] = 1
phenos$cad[which(phenos$x131306_0_0!="")] = 1
phenos$cad[which(phenos$x131307_0_0!="")] = 1


## check difference of 6150 vs first occurrences

col6150 = which(grepl('6150_0', colnames(phenos)))
x = which(apply(phenos[,col6150], 1, function(r) any(r == 1 | r ==2)))
length(x)

x = which(apply(phenos[,col6150], 1, function(r) any(r == 1 | r ==2)) & phenos$cad == 1)
length(x)
x = which(apply(phenos[,col6150], 1, function(r) any(r == 1 | r ==2)) & phenos$cad == 0)
length(x)


## check difference of 20002 vs first occurrences

col20002 = which(grepl('20002_0', colnames(phenos)))
x = which(apply(phenos[,col20002], 1, function(r) any(r == 1074 | r ==1075)) & phenos$cad == 1)
length(x)
x = which(apply(phenos[,col20002], 1, function(r) any(r == 1074 | r ==1075)) & phenos$cad == 0)
length(x)



## make our CAD definition

ix = which(apply(phenos[,col6150], 1, function(r) any(r == 1 | r == 2)))
phenos$cad[ix] = 1

ix = which(apply(phenos[,col20002], 1, function(r) any(r == 1074 | r ==1075)))
phenos$cad[ix] = 1

table(phenos$cad)


colnames(phenos)[which(colnames(phenos) == "x30710_0_0")] = "crp"

#phenos = phenos[,c('eid', 'cad', 'crp')]


return(phenos)

}


