require 'tied-up-normal'
require 'mle-via-newton'
require 'gsl'

data = [3.08, 0.68, 2.09, 0.87, -0.02, 0.25, 1.98, 1.47, 1.95, 0.99]
tied_up_normal = TiedUpNormal.new(data)
iterations = mle_via_newton(tied_up_normal,GSL::Vector.alloc([0.95]))
puts "After #{iterations} iteration#{iterations == 0 ? '' : 's'}, the MLE is #{tied_up_normal.parameter[0]}."


