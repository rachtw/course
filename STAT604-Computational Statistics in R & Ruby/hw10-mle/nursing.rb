require 'logistic-regression'
require 'mle-via-newton'
require 'gsl'

# x: Gestational age of the infant (in weeks) at the time of birth
# y: Number of infants that were breast feeding at the time of release from hospital
# N: Total number of infants
x = [28,29,30,31,32,33]
y = [ 2, 2, 7, 7,16,14]
n = [ 6, 5, 9, 9,20,15]

logistic_regression = LogisticRegression.new(x,y,n)
iterations = mle_via_newton(logistic_regression,GSL::Vector.alloc([-13.0,0.8]))
mle = logistic_regression.parameter.to_a
puts "After #{iterations} iteration#{iterations == 0 ? '' : 's'}, I say  the MLE is (#{mle.join(', ')})."

require 'dbd/R'
$R.echo(false)
$R.assign("x",x)
$R.assign("y",y)
$R.assign("n",n)
$R.eval <<EOF
  # Expand the data from binomial counts to individual Bournouli realizations.
  response <- numeric(sum(n))
  predictor <- numeric(sum(n))
  index <- 1
  for ( i in 1:length(y) ) {
    indices <- index:(index+n[i]-1)
    response[indices] <- c(rep(1,y[i]),rep(0,n[i]-y[i]))
    predictor[indices] <- rep(x[i],n[i])
    index <- index + n[i]
  }
  fitted.logistic.model <- glm( response ~ predictor, family=binomial(link=logit) )
  print(summary(fitted.logistic.model))
EOF
mle_from_R = $R.pull("fitted.logistic.model$coef")
iterations_in_R = $R.pull("fitted.logistic.model$iter")
puts "After #{iterations_in_R} iteration#{iterations_in_R == 0 ? '' : 's'}, R says the MLE is (#{mle_from_R.join(', ')})."
