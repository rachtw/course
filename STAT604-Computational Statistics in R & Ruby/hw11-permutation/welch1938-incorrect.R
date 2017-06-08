# Pooled variance t-test (equal variance assumed)
t.test.pool <- function(y1,y2,alpha=0.05) {
  n1 <- length(y1)
  n2 <- length(y2)
  s1 <- sqrt(var(y1))
  s2 <- sqrt(var(y2))
  df <- n1 + n2 - 2
  s.pool <- sqrt( ( (n1-1)*s1^2 + (n2-1)*s2^2 ) / ( n1 + n2 - 2 ) )
  test.statistic <- ( mean(y1) - mean(y2) ) / ( s.pool * sqrt( 1.0/n1 + 1.0/n2 ) )
  if ( abs(test.statistic) >= qt(1-alpha/2,df) ) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

# Seperate variance t-test (Law of Large Numbers applied)
t.test.clt <- function(y1,y2,alpha=0.05) {
  n1 <- length(y1)
  n2 <- length(y2)
  s1 <- sqrt(var(y1))
  s2 <- sqrt(var(y2))
  df <- n1 + n2 - 2
  test.statistic <- ( mean(y1) - mean(y2) ) / sqrt( s1^2/n1 + s2^2/n2 )
  if ( abs(test.statistic) >= qnorm(1-alpha/2) ) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

# Welch approximation t-test (degrees of freedom motified)
t.test.welch <- function(y1,y2,alpha=0.05) {
  n1 <- length(y1)
  n2 <- length(y2)
  s1 <- sqrt(var(y1))
  s2 <- sqrt(var(y2))
  k <- (s1^2/n1) / (s1^2/n1 + s2^2/n2)
  df <- (n1-1)*(n2-1)/((1-k)^2*(n1-1)+k^2*(n2-1))
  test.statistic <- ( mean(y1) - mean(y2) ) / sqrt( s1^2/n1 + s2^2/n2 )
  if ( abs(test.statistic) >= qt(1-alpha/2,df) ) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}

# Permutation test under the assumption that the variances are equal
z.test.permute1 <- function(y1.original,y2.original,alpha=0.05) {
  n1 <- length(y1.original)
  n2 <- length(y2.original)
  n <- n1 + n2
  s1 <- sqrt(var(y1.original))
  s2 <- sqrt(var(y2.original))
  df <- n - 2
  test.statistic <- ( mean(y1.original) - mean(y2.original) ) / sqrt( s1^2/n1 + s2^2/n2 )

  n.permutations <- 100
  draws <- numeric(n.permutations)
  y <- numeric(n)
  for ( i in 1:n.permutations ) {
    y[1:n1] <- y1.original
    y[(n1+1):n] <- y2.original
    y <- sample(y,n)   # Permute
    y1 <- y[1:n1]
    y2 <- y[(n1+1):n]
    s1 <- sqrt(var(y1))
    s2 <- sqrt(var(y2))
    draws[i] <- ( mean(y1) - mean(y2) ) / sqrt( s1^2/n1 + s2^2/n2 )
  }
  p.value = ( sum( draws > abs(test.statistic) ) + sum( draws < -abs(test.statistic) ) ) / length(draws)
  if ( p.value <= alpha ) {
    return(FALSE)
  } else {
    return(TRUE)
  }
}

# Permutation test under where the data are transformed 
# such that the means are unchanged, but the sample variances are equal
z.test.permute2 <- function(y1.original,y2.original,alpha=0.05) {
  set.seed(536)                      # Set the random number seed so results
                                     # can be exactly replicated.
  return(z.test.permute1(y1.original / sqrt(var(y1.original)),
  y2.original / sqrt(var(y2.original)),alpha))
}


# Simulation parameters
n1 <- 6
n2 <- 10
mu1 <- 0
sigma1 <- 1
mu2 <- c(0,0.5,1.0,2.0)
sigma2 <- c(0.25,1.0,2.0,5.0)
nreps <- 10000
alpha <- 0.10


# Storage for point estimates of power with row and column labels
# Note: You might be tempted to call the variable "dimnames", but that
#       would mask the function with the same name.
dnames <- list(paste("sigma2=",sigma2,sep=""),paste("mu2=",mu2,sep=""))
power.pool <- matrix(NA,nrow=length(sigma2),ncol=length(mu2),dimnames=dnames)
power.clt <- matrix(NA,nrow=length(sigma2),ncol=length(mu2),dimnames=dnames)
power.welch <- matrix(NA,nrow=length(sigma2),ncol=length(mu2),dimnames=dnames)
power.permute1 <- matrix(NA,nrow=length(sigma2),ncol=length(mu2),dimnames=dnames)
power.permute2 <- matrix(NA,nrow=length(sigma2),ncol=length(mu2),dimnames=dnames)

# Storage for confidence intervals of power
dnames <- list(paste("sigma2=",sigma2,sep=""),rep(paste("mu2=",mu2,sep=""),each=2))
ci.pool <- matrix(NA,nrow=length(sigma2),ncol=2*length(mu2),dimnames=dnames)
ci.clt <- matrix(NA,nrow=length(sigma2),ncol=2*length(mu2),dimnames=dnames)
ci.welch <- matrix(NA,nrow=length(sigma2),ncol=2*length(mu2),dimnames=dnames)
ci.permute1 <- matrix(NA,nrow=length(sigma2),ncol=2*length(mu2),dimnames=dnames)
ci.permute2 <- matrix(NA,nrow=length(sigma2),ncol=2*length(mu2),dimnames=dnames)

for ( i in 1:length(sigma2) ) {
  for ( j in 1:length(mu2) ) {
    results <- matrix(NA,nrow=nreps,ncol=5)
    for ( k in 1:nreps ) {
      y1 <- rnorm(n1,mean=mu1,sd=sigma1)
      y2 <- rnorm(n2,mean=mu2[j],sd=sigma2[i])
      results[k,1:3] <- c(t.test.pool(y1,y2,alpha),t.test.clt(y1,y2,alpha),t.test.welch(y1,y2,alpha))
    }
    # Point estimates (the power here actually means p-value)
    power.pool[i,j]  <- mean(results[,1])
    power.clt[i,j]   <- mean(results[,2])
    power.welch[i,j] <- mean(results[,3])

    # 95% confidence interval
    ci.pool[i,rep(2*(j-1),2)+c(1,2)]  <- power.pool[i,j]  + c(-1,1) * 1.96 * sqrt( var(results[,1])/nreps )
    ci.clt[i,rep(2*(j-1),2)+c(1,2)]   <- power.clt[i,j]   + c(-1,1) * 1.96 * sqrt( var(results[,2])/nreps )
    ci.welch[i,rep(2*(j-1),2)+c(1,2)] <- power.welch[i,j] + c(-1,1) * 1.96 * sqrt( var(results[,3])/nreps )
  }
}

nreps <- 100
for ( i in 1:length(sigma2) ) {
  for ( j in 1:length(mu2) ) {
    for ( k in 1:nreps ) {
      y1 <- rnorm(n1,mean=mu1,sd=sigma1)
      y2 <- rnorm(n2,mean=mu2[j],sd=sigma2[i])
      results[k,4:5] <- c(z.test.permute1(y1,y2,alpha),z.test.permute2(y1,y2,alpha))
    }
    # Point estimates
    power.permute1[i,j] <- mean(results[1:nreps,4])
    power.permute2[i,j] <- mean(results[1:nreps,5])

    # 95% confidence interval
    ci.permute1[i,rep(2*(j-1),2)+c(1,2)] <- power.permute1[i,j] + c(-1,1) * 1.96 * sqrt( var(results[1:nreps,4])/nreps )
    ci.permute2[i,rep(2*(j-1),2)+c(1,2)] <- power.permute2[i,j] + c(-1,1) * 1.96 * sqrt( var(results[1:nreps,5])/nreps )
  }
}

power.pool
power.clt
power.welch
power.permute1
power.permute2

ci.pool
ci.clt
ci.welch
ci.permute1
ci.permute2
