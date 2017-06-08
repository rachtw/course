# Make available the things defined in 'distributions.rb' in the current
# working directory.
require './distributions'

require './normal'
require './logistic'

# Make available the method defined in 'rejection-sampler.rb' in the
# current working directory.
require './rejection-sampler'

# Let's try it out!
mean, variance = 3, 4
normal = Normal.new(mean,variance)
c =  Math.exp(normal.log_density(normal.mode))
draws = sample_via_rejection(normal,Logistic.new,c,1000)
puts draws
