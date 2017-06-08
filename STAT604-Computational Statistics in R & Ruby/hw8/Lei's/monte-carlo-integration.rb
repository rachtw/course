require './distributions'
require './importance-sampler.rb'
require './weightedmontecarlo.rb'
require 'dbd/broccoli'

alpha1, alpha2 = 5, 2
beta = Beta.new(alpha1,alpha2)

input= sample_via_importance(beta,Uniform.new,10000)
draws=input[0]
weights=input[1]

# Estimate E(X) "by hand"
sum = 0.0
draws.each_index { |i| sum += draws[i]*weights[i] }
mean1 = sum.to_f / draws.length
puts mean1



include DBD::Broccoli::Integration::WeightedMonteCarlo

# Estimate E(X) using 'integrate' from DBD::Broccoli::Integration::weightedMonteCarlo
mean2 = integrate(draws,weights) { |x| x }
puts mean2

# Are they the same?
raise "Not equal!" if mean1 != mean2

# Estimate E(X) using the convenient method 'mean' from DBD::Broccoli::Integration::MonteCarlo
mean3 = mean(draws,weights)
puts mean3

# Are they the same?
raise "Not equal!" if mean2 != mean3



puts median(draws,weights)

puts variance(draws,weights)

puts stdev(draws,weights)

puts percentile(1.0,draws,weights)

puts percentile(0.5,draws,weights)

puts percentile(0.0,draws,weights)

puts quantile(0.5,draws,weights)

puts interval(0.95,draws,weights)


