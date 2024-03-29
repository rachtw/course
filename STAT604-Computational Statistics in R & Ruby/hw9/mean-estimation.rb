require './mcmc-sampler'

class NormalUniformPosterior < Model

  require 'gsl'
  include Math
  include GSL::Sf

  def initialize(x,sigma,min,max)
    @x = x
    @sigma = sigma.to_f
    @min = min
    @max = max
  end

  def log_density(state)
    if state[0] <= @max && state[0] >= @min
      result = 0.0    
      @x.each_index { |i| result += -0.5*(((@x[i]-state[0])/@sigma)**2) }
      result
    else
      -1.0/0.0
    end
  end
  
end

# x: sample
x = [3.08, 0.68, 2.09, 0.87, -0.02, 0.25, 1.98, 1.47, 1.95, 0.99]

sigma = 1
min = 1
max = 3

normal_uniform_posterior = NormalUniformPosterior.new(x,sigma,min,max)
initial_state = [2.0]
step_width = 0.1
proposal_distributions = [UnivariateUniformRandomWalk.new(step_width,0)]
draws, rate = sample_via_mcmc(normal_uniform_posterior,initial_state,proposal_distributions,20000)
puts "Acceptance rate is: #{rate}"

require 'dbd/broccoli'

include DBD::Broccoli::Integration::MonteCarlo

mu = draws.collect { |x| x[0] }

puts mean(mu)
puts stdev(mu)
puts percentile(0.017,mu)


