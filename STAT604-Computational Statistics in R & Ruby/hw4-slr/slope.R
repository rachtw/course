## You should not modify the function definition.
## Also, you should not add any code before or after this function.
slope.simulation <- function(regressor,intercept,slope,error.distribution=c("normal","chisq")[1],nreps,alpha1,alpha2) {
  ## Your code goes here
  bias <- numeric(nreps)
  coverage <- integer(nreps)
  n <- length(regressor)
  
  if (error.distribution=="normal") {
    for ( i in 1:nreps ) {    
      error <- rnorm(n,0,1)
      response <- intercept + slope * regressor + error
      fm <- lm( response ~ regressor)
      slope.estimate <- coefficients(fm)[2]
      bias[i] <- slope.estimate - slope
      slope.SE <- coefficients(summary(fm))[2,2]
      confidence.interval <- slope.estimate + c(-1,1) * qt(1-alpha1/2,n-2) * slope.SE
      if (slope >= confidence.interval[1] && slope <= confidence.interval[2]) {
        coverage[i] <- 1
      } else {
        coverage[i] <- 0
      }
    }
  } else {
    for ( i in 1:nreps ) {    
      error <- rchisq(length(x),0.5,0.5)
      response <- intercept + slope * regressor + error
      fm <- lm( response ~ regressor)
      slope.estimate <- coefficients(fm)[2]
      bias[i] <- slope.estimate - slope
      slope.SE <- coefficients(summary(fm))[2,2]
      confidence.interval <- slope.estimate + c(-1,1) * qt(1-alpha1/2,n-2) * slope.SE
      if (slope >= confidence.interval[1] && slope <= confidence.interval[2])
        coverage[i] <- 1
      else
        coverage[i] <- 0
    }
  }
  results <- numeric(6)
  results[1] = mean(bias)
  results[2:3] = results[1] + c(-1,1) * qnorm(1-alpha2/2,0,1) * sqrt( var(bias)/nreps )
  results[4] = mean(coverage)
  results[5:6] = results[4] + c(-1,1) * qnorm(1-alpha2/2,0,1) * sqrt( var(coverage)/nreps )
  return(results)
}

