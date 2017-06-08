require './distributions'
require './importance-sampler'
require 'dbd/broccoli'

alpha1, alpha2 = 5, 2
results = sample_via_importance(Beta.new(alpha1,alpha2),Uniform.new,10000)
draws, weights = results[0], results[1]


# Estimate E(X) "by hand"
sum = 0.0
draws.each_index { |i| sum += draws[i] }
mean1 = sum.to_f / draws.length
puts mean1

include DBD::Broccoli::Integration::WeightedMonteCarlo

# Estimate E(X) using 'integrate' from DBD::Broccoli::Integration::WeightedMonteCarlo
mean2 = integrate(draws,weights) { |x| x }
puts mean2

# Are they the same?
#raise "Not equal!" if mean1 != mean2
puts "Not equal!" if mean1 != mean2

# Estimate E(X) using the convenient method 'mean' from DBD::Broccoli::Integration::WeightedMonteCarlo
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

