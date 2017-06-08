require './mcmc-sampler'

class LogisticRegression < Model

  require 'gsl'
  include Math
  include GSL::Sf

  def initialize(x,y,n,b0,b1,s0,s1)
    @X = x
    @Y = y
    @N = n
    @hyperparameters = [ [b0.to_f, s0.to_f],
                         [b1.to_f, s1.to_f] ]
  end

  def log_density(state)
    result = 0.0
    p = @X.collect { |x| 1.0 / ( 1.0 + exp(-(state[0] + state[1]*x)) ) }
    @Y.each_index { |i| result += @Y[i]*log(p[i]) + (@N[i]-@Y[i])*log(1.0-p[i]) }
    for i in 0..1
      result -= 0.5*(((state[i]-@hyperparameters[i][0])/@hyperparameters[i][1])**2)
    end
    result
  end

end

# x: Gestational age of the infant (in weeks) at the time of birth
# y: Number of infants that were breast feeding at the time of release from hospital
# n: Total number of infants
x = [28,29,30,31,32,33]
y = [ 2, 2, 7, 7,16,14]
n = [ 6, 5, 9, 9,20,15]

# b0 is the mean of the normal prior distribution for Beta0
# b1 is the mean of the normal prior distribution for Beta1
# s0 is the std. dev. of the normal prior distribution for Beta0
# s1 is the std. dev. of the normal prior distribution for Beta1
b0 = -10.0
b1 = 0.4
s0 = 10.0
s1 = 0.4

logistic_regression = LogisticRegression.new(x,y,n,b0,b1,s0,s1)
initial_state = [ b0, b1 ]
proposal_distributions = [ UnivariateUniformRandomWalk.new(1.0,0), UnivariateUniformRandomWalk.new(0.05,1) ]
# proposal_distributions = [ BivariateNormalRandomWalk.new(0.75,0.05,-0.99) ]
draws, rate = sample_via_mcmc(logistic_regression,initial_state,proposal_distributions,20000)
puts "Acceptance rate is: #{rate}"



require 'dbd/R'

beta0 = draws.collect { |x| x[0] }
beta1 = draws.collect { |x| x[1] }
$R.assign("beta0",beta0)
$R.assign("beta1",beta1)

$R.eval <<EOF
  write(beta0,"beta0")
  write(beta1,"beta1")
  plot(beta0,type="l")
  locator(1)   # To induce a pause before going to the next figure
  plot(beta1,type="l")
  locator(1)
  hist(beta0,freq=FALSE)
  locator(1)
  hist(beta1,freq=FALSE)
  locator(1)
  plot(beta0,beta1)
  print(cor(beta0,beta1))
  locator(1)
EOF

