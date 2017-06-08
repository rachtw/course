coal <- read.table("coal.dat",header=TRUE)
x <- coal$disasters
x_total <- 0
for ( i in 1:length(x) ) {
	x_total <- x_total + x[i]
}
nreps <- 10000
draws <- matrix(0,nrow=nreps,ncol=4)

alpha_sampling <- function(lambda1,lambda2) {
	return(rgamma(1,16,rate=(10+lambda1+lambda2)))
}

lambda_sampling <- function(x,theta,alpha) {
	sum <- 0
	for ( i in 1:theta ) {
		sum <- sum + x[i]
	}
	return(c(rgamma(1,3+sum,rate=(theta+alpha)),rgamma(1,3+x_total-sum,rate=(length(x)-theta+alpha))))
}

theta_conditional <- function(x,theta,lambda1,lambda2) {
	if (theta > 0 && theta < length(x)) {
		sum <- 0
		for ( i in 1:theta ) {
			sum <- sum + x[i]
		}
		return((lambda1^sum)*(lambda2^(x_total-sum))*exp((lambda2-lambda1)*theta))
	} else
		return(0)
}

theta_sampling <- function(x,lambda1,lambda2) {
	th <- numeric(length(x))
	sum <- 0
      th[1] <- theta_conditional(x,1,lambda1,lambda2)
	for ( i in 2:length(x) ) {
		th[i] <- th[i-1] + theta_conditional(x,i,lambda1,lambda2)
	}
      th <- th / th[length(th)]
	u1 <- runif(1)
      for (i in 1:length(th)) {
		if (u1 <= th[i]) {
		      return(i)
		}
      }
	return(length(th))
}

# Initial sample
for ( i in 1:3 ) {
	draws[1,i] <- 0
}
draws[1,4] <- 50
# Sampling using Gibbs sampler
for ( j in 2:nreps ) {
	draws[j,1] <- alpha_sampling(draws[j-1,2],draws[j-1,3])
	lambda <- lambda_sampling(x,draws[j-1,4],draws[j,1])
	draws[j,2] <- lambda[1]
	draws[j,3] <- lambda[2]
	draws[j,4] <- theta_sampling(x,lambda[1],lambda[2])
}
# Autocorrelation
correlation <- matrix(0,nrow=(nreps/2),ncol=3)
for (i in 1:(nreps/2)) {
	for (j in 1:3) {
		correlation[i,j] <- cor(draws[1:(nreps-i),j+1],draws[(i+1):nreps,j+1])
	}
}

# Mean and confidence interval
print("Mean and confidence interval of lambda 1:")
lambda1 <- mean(draws[,2])
lambda1
lambda1 + c(-1,1) * 1.96 * sqrt( var(draws[,2])/nreps )
print("Mean and confidence interval of lambda 2:")
lambda2 <- mean(draws[,3])
lambda2
lambda2 + c(-1,1) * 1.96 * sqrt( var(draws[,3])/nreps )
print("Mean and confidence interval of theta:")
theta <- mean(draws[,4])
theta
theta + c(-1,1) * 1.96 * sqrt( var(draws[,4])/nreps )

postscript("plots.ps",width=5.5,height=5)
# Density histogram
plot(density(draws[,2]),main=paste("Density of lambda 1, mean=",lambda1))
plot(density(draws[,3]),main=paste("Density of lambda 2, mean=",lambda2))
plot(density(draws[,4]),main=paste("Density of theta, mean=",theta))

# Sample paths
plot(1:nreps,draws[1:nreps,2],ylab="lambda 1",xlab="t",main="Sample path for lambda 1")
plot(1:nreps,draws[1:nreps,3],ylab="lambda 2",xlab="t",main="Sample path for lambda 2")
plot(1:nreps,draws[1:nreps,4],ylab="theta",xlab="t",main="Sample path for theta")

# Autocorrelation plots
plot(1:(nreps/2),correlation[1:(nreps/2),1],ylab="Correlation",xlab="Lag",main="Autocorrelation plots for lambda 1")
plot(1:(nreps/2),correlation[1:(nreps/2),2],ylab="Correlation",xlab="Lag",main="Autocorrelation plots for lambda 2")
plot(1:(nreps/2),correlation[1:(nreps/2),3],ylab="Correlation",xlab="Lag",main="Autocoorelation plots for theta")
dev.off()
