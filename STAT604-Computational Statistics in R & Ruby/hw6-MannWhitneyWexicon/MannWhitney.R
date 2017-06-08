mann.whitney <- function(sample1,sample2,nreps=10000) {
  results <- numeric(3)
  n1 <- length(sample1)
  n2 <- length(sample2)
  sample1 <- sort(sample1)
  sample2 <- sort(sample2)

  # U Statistic
  i <- 1
  j <- 1
  U1 <- 0
  U2 <- 0
  repeat {
    if (i > n1 || j > n2)
      break
    if (sample1[i] < sample2[j]) {
      U2 <- U2 + n2 - j + 1
      i <- i + 1
    } else if (sample2[j] < sample1[i]) {
      U1 <- U1 + n1 - i + 1
      j <- j + 1
    }
  }
  if (U1 < U2)
    results[1] = U1
  else
    results[1] = U2

  # Monte Carlo
  compare <- numeric(nreps)
  if (U1 < U2) {
    for (i in 1:nreps) {
      draws <- sample(1:(n1+n2),n1,replace=FALSE)
      U <- sum(draws) - n1*(n1+1)/2
      compare[i] = U < results[1]
    }
  } else {
    for (i in 1:nreps) {
      draws <- sample(1:(n1+n2),n2,replace=FALSE)
      U <- sum(draws) - n2*(n2+1)/2
      compare[i] = U < results[1]
    }
  }
  results[2] = 2 * mean(compare)

  # Normal Approximation
  z = (results[1] - (n1*n2/2) ) / sqrt(n1*n2*(n1+n2+1) / 12)
  results[3] = 2 * pnorm(z)

  return(results)
}