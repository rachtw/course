require 'binomial'
require 'mle-via-newton'
require 'gsl'

binomial = Binomial.new(21,50)
iterations = mle_via_newton(binomial,GSL::Vector.alloc([0.10]))
puts "After #{iterations} iteration#{iterations == 0 ? '' : 's'}, the MLE is #{binomial.parameter[0]}."
