# Read in the simulation function 
source("slope.R")

x <- seq(-2,2,length=5)
beta0 <- 2
beta1 <- 3
nreps <- 1000
alpha1 <- 0.10
alpha2 <- 0.05

for ( error.dist in c("normal","chisq") ) {
  cat("Results for ",c("normal","chisquared")[(error.dist!="normal")+1]," errors:\n",sep="")
  results <- slope.simulation(x,beta0,beta1,error.dist,nreps,alpha1,alpha2)
  cat("  Bias:      ",results[1]," (",results[2],",",results[3],")\n",sep="")
  cat("  Coverage:  ",results[4]," (",results[5],",",results[6],")\n",sep="")
  cat("\n")
}

