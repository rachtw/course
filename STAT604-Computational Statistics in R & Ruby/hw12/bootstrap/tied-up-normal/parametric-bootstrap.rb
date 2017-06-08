require 'tied-up-normal'
require 'mle-via-newton'
require 'random-normals2'

require 'dbd/broccoli'
include DBD::Broccoli::Integration::MonteCarlo

n_bootstrap_samples = 1000

data = [ 6.880259,11.142090,12.823983,11.233820, 5.838140,10.349926, 5.700715,
        13.538221, 6.978450,10.144478,17.121443, 9.176535, 7.474128, 9.494064,
         7.877830, 9.714031,15.667606,10.034336, 5.612008,13.191355, 9.672272,
         9.137568,10.448955, 8.562064, 7.561597, 7.253730, 6.972253, 9.097176 ]

xbar = mean(data)
s2 = variance(data)

tied_up_normal = TiedUpNormal.new(data)
mle_via_newton(tied_up_normal,GSL::Vector.alloc([data.inject {|s,x| s += x}/data.length]))
point_estimate = tied_up_normal.parameter[0]

bootstrap_estimates = Array.new(n_bootstrap_samples)
for rep in 0...n_bootstrap_samples
  bootstrap_sample = random_normal(data.length,xbar,s2)
  tied_up_normal = TiedUpNormal.new(bootstrap_sample)
  begin
    mle_via_newton(tied_up_normal,GSL::Vector.alloc([data.inject {|s,x| s += x}/data.length]))
    bootstrap_estimates[rep] = tied_up_normal.parameter[0]
  rescue StandardError => msg
    puts msg
  end
end

puts "Point estimate parameter:  #{point_estimate}"
puts "95% bootstrap CI:          (#{quantile(0.025,bootstrap_estimates)}, #{quantile(0.975,bootstrap_estimates)})"

