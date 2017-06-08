set.seed(13242)

data <- c(4.026391, 4.318672, 4.137833, 4.513251, 4.439149, 4.663943, 4.235100, 5.602739, 4.705160, 2.969985)
#data <- runif(15)

point.estimate <- mean(data)
point.estimate


# t-distribution based confidence interval
# Appropriate only if data are drawn from normal distribution
t.test(data)


# Bootstrap
n.bootstrap.samples <- 1000
bootstrap.samples <- numeric(n.bootstrap.samples)
for ( i in 1:n.bootstrap.samples ) {
  bs.sample <- sample(data,length(data),replace=TRUE)
  bootstrap.samples[i] <- mean(bs.sample)
}
ci <- c(quantile(bootstrap.samples,0.025),quantile(bootstrap.samples,0.975))
ci
hist(data)
hist(bootstrap.samples)


# Parametric bootstap (e.g., sampling distribution of data is assumed to be normal)
# Estimate parameters of unknown distribution
n.bootstrap.samples <- 1000
xbar <- mean(data)
s2 <- var(data)
bootstrap.samples <- numeric(n.bootstrap.samples)
for ( i in 1:n.bootstrap.samples ) {
  bs.sample <- rnorm(length(data),mean=xbar,sd=sqrt(s2))
  bootstrap.samples[i] <- mean(bs.sample)
}
ci <- c(quantile(bootstrap.samples,0.025),quantile(bootstrap.samples,0.975))
ci
hist(bootstrap.samples)




