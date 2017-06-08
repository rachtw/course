a <- 5
b <- 2

draws <- numeric(100000)

doit <- function(d) {
  draws[1] <- 0.5
  accept <- 0
  for ( i in 2:length(draws) ) {
    # g() = uniform distribution centered at draws[i-1], which is symmetric
    proposal <- draws[i-1] + runif(1,-d,d) 
    # p() = Beta
    hastings <- dbeta(proposal,a,b) / dbeta(draws[i-1],a,b) 
    if ( runif(1) < hastings ) {
      draws[i] <- proposal
      accept <- accept + 1
    } else {
      draws[i] <- draws[i-1]
    }
  }

  plot(density(draws))
  x <- seq(0,1,length=100)
  lines(x,dbeta(x,a,b),col="red")

  #plot(draws,type="l",main=paste("d =",d))
  return(accept/length(draws))
}

par(ask=TRUE)

doit(0.1)

doit(1)

doit(100)

doit(0.001)

