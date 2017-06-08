ndraws <- 100000
mean <- 3
sd <- sqrt(4)

#################################################################
# What about using the logistic distribution as the importance distribution?
#################################################################

x <- seq(-4,10,length=100)
plot(x,dnorm(x,mean=mean,sd=sd),type="l")
s <- 1.5
lines(x,dlogis(x,location=mean,scale=s),col="red")

draws <- rlogis(ndraws,location=mean,scale=s)
weights <- dnorm(draws,mean=mean,sd=sd) / dlogis(draws,location=mean,scale=s)
hist(weights)
max(weights)/median(weights)
mean(weights)

eX  <- mean(weights*draws)
eX2 <- mean(weights*draws^2)

variance <- eX2 - eX^2
variance
var(draws)


# h(x) = sqrt(abs(x))
y <- weights*sqrt(abs(draws))
est <- mean(y)

# How good is our estimate?
# 95% confidence interval...
est + c(-1,1)*qnorm(0.975)*sqrt(var(y)/length(y))



#################################################################
# What about using the double exponential distribution as the importance distribution?
#################################################################

x <- seq(-4,10,length=100)
plot(x,dnorm(x,mean=mean,sd=sd),type="l")
lines(x,dexp(abs(x)),col="red")

draws <- rexp(ndraws) * ( 2*rbinom(ndraws,1,0.5)-1 )
weights <- dnorm(draws,mean=mean,sd=sd) / (dexp(abs(draws))/2)
hist(weights)
max(weights)/median(weights)
mean(weights)

eX  <- mean(weights*draws)
eX2 <- mean(weights*draws^2)

variance <- eX2 - eX^2
variance
var(draws)


# h(x) = sqrt(abs(x))
y <- weights*sqrt(abs(draws))
est <- mean(y)

# How good is our estimate?
# 95% confidence interval...
est + c(-1,1)*qnorm(0.975)*sqrt(var(y)/length(y))



