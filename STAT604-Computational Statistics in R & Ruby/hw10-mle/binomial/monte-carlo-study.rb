require 'random-binomial'
require 'mle-via-newton'
require 'logistic-regression'
require 'gsl'
require 'dbd/broccoli'
include DBD::Broccoli::Integration::MonteCarlo

def monte_carlo_study_mle(x,n,beta,initial_beta,nreps)

  y = Array.new(n.length)
  beta0 = Array.new(nreps)
  beta1 = Array.new(nreps)
  iterations = Array.new(nreps)
  
  for j in 0..nreps-1
  
    for i in 0..y.length-1
      exponent = beta[0] + x[i]*beta[1]
      y[i] = random_binomial( n[i], 1/(1+Math.exp(-exponent)) )
    end
    
    logistic_regression = LogisticRegression.new(y,x,n)
    iterations[j] = mle_via_newton(logistic_regression,initial_beta)
  
    beta0[j] = logistic_regression.parameter[0]
    beta1[j] = logistic_regression.parameter[1]
  
    #puts "After #{iterations[j]} iteration#{iterations == 0 ? '' : 's'},"  
    #puts "the MLE of beta0 is #{beta0[j]},"
    #puts "and the MLE of beta1 is #{beta1[j]}."
  end
  
  puts "After #{mean(iterations)} iteration#{iterations == 0 ? '' : 's'},"
  puts "the MLE of beta0 is #{beta0_mean=mean(beta0)},"
  puts "and the MLE of beta1 is #{beta1_mean=mean(beta1)}."
  
  puts "The bias of beta0 estimate is #{beta0_mean-beta[0]}."
  puts "The bias of beta1 estimate is #{beta1_mean-beta[1]}."
  
  puts "The C.I. of beta0 estimate is #{interval(0.95,beta0)[0]} #{interval(0.95,beta0)[1]}"
  puts "The C.I. of beta1 estimate is #{interval(0.95,beta1)[0]} #{interval(0.95,beta1)[1]}"

end

nreps = 1000
x = [ 5, 6, 7, 8, 9, 10]
n = [10, 10, 5, 5, 10, 10]
beta = [-7.0, 0.9]
beta0 = -2.0
beta1 = 0.1
initial_beta=GSL::Vector.alloc([beta0, beta1])

puts "Initial estimates: beta0=#{beta0} beta1=#{beta1}"
puts "\n"

puts "n = [10, 10, 5, 5, 10, 10]"
monte_carlo_study_mle(x,n,beta,initial_beta,nreps)

n = [40, 40, 20, 20, 40, 40]
puts "\nn = [40, 40, 20, 20, 40, 40]"
monte_carlo_study_mle(x,n,beta,initial_beta,nreps)