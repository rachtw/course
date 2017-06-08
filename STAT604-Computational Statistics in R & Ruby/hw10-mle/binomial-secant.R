# Log of the likelihood (without the constant)
log.likelihood <- function(pi,successes,n.trials) {
  successes * log(pi) + (n.trials - successes) * log(1-pi)
}

# First derivative of log likelihood
d1.log.likelihood <- function(pi,successes,n.trials) {
  successes/pi - (n.trials - successes)/(1-pi)
}

## Second derivative of log likelihood
#d2.log.likelihood <- function(pi,successes,n.trials) {
#  -successes/pi^2 - (n.trials - successes)/(1-pi)^2
#}

find.mle <- function(successes,n.trials,initial.estimate.1,initial.estimate.2,tolerance=0.01,show.plots=TRUE,pause=TRUE) {
  if ( show.plots && pause ) {
    old.ask <- par()$ask
    par(ask=TRUE)
  }
  prev.estimate <- initial.estimate.1
  estimate <- initial.estimate.2
  iter <- 0
  while ( abs(d1.log.likelihood(estimate,successes,n.trials)) > tolerance ) {
    b <- d1.log.likelihood(estimate,successes,n.trials)
    c <- ( d1.log.likelihood(estimate,successes,n.trials) - d1.log.likelihood(prev.estimate,successes,n.trials) ) / ( estimate - prev.estimate )
    new.estimate <- estimate - b/c
    if ( show.plots ) {
      a <- log.likelihood(estimate,successes,n.trials)
      pi <- seq(0,1,by=0.01)
      ll <- log.likelihood(pi,successes,n.trials)
      plot(pi,ll,ylab="Log-Likelihood",type="l")
      abline(v=estimate)
      abline(v=new.estimate,col="red")
      taylor.approx <- a + b*(pi-estimate) + 0.5*c*(pi-estimate)^2
      lines(pi,taylor.approx,col="green")
    }
    prev.estimate <- estimate
    estimate <- new.estimate
    iter <- iter + 1
  }
  cat("It took",iter,"iterations.\n")
  if ( show.plots && pause ) {
    par(ask=old.ask)
  }
  estimate
}

successes <- 21
n.trials <- 50

mle.via.secant <- find.mle(successes,n.trials,0.05,0.00001,TRUE,TRUE)
mle.via.secant

mle.via.analyticals <- successes/n.trials
mle.via.analyticals


