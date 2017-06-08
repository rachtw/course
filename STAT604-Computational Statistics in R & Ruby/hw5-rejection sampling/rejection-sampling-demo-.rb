# Make available the things defined in 'distributions.rb' in the current
# working directory.
require './distributions'

# Make available the method defined in 'rejection-sampler.rb' in the
# current working directory.
require './rejection-sampler'

# Let's try it out!
alpha1, alpha2 = 5, 2
beta = Beta.new(alpha1,alpha2)
c =  Math.exp(beta.log_density(beta.mode))
draws = sample_via_rejection(beta,Uniform.new,c,10000)
puts draws

