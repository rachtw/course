require './distributions'
require './rejection-sampler'
require 'dbd/broccoli'

alpha1, alpha2 = 5, 2
beta = Beta.new(alpha1,alpha2)
c =  Math.exp(beta.log_density(beta.mode))
draws = sample_via_rejection(beta,Uniform.new,c,10000)


# Estimate E(X) "by hand"
sum = 0.0
draws.each_index { |i| sum += draws[i] }
mean1 = sum.to_f / draws.length
puts mean1



include DBD::Broccoli::Integration::MonteCarlo

# Estimate E(X) using 'integrate' from DBD::Broccoli::Integration::MonteCarlo
mean2 = integrate(draws) { |x| x }
puts mean2

# Are they the same?
raise "Not equal!" if mean1 != mean2

# Estimate E(X) using the convenient method 'mean' from DBD::Broccoli::Integration::MonteCarlo
mean3 = mean(draws)
puts mean3

# Are they the same?
raise "Not equal!" if mean2 != mean3



puts median(draws)

puts variance(draws)

puts stdev(draws)

puts percentile(1.0,draws)

puts percentile(0.5,draws)

puts percentile(0.0,draws)

puts quantile(0.5,draws)

puts interval(0.95,draws)

