# A method taking the following arguments:
#     target_distribution: an object of class Distribution
#     envelope_distribution: an object of class SamplableDistribution
#     c: an object of class Float (i.e., a double) such that 'c' times the
#        density of envelope distribution evaluated at 'x' is always
#        greater than the density of the target distribution evaluated at 'x'.
#     sample_size: an object of class Fixnum (i.e., an integer)
# The method returns 'sample_size' realizations from the target distribution.
def sample_via_rejection(target_distribution,envelope_distribution,
                         c,sample_size)
  ##
  ## Your code goes here.
  ## 
  draws = Array.new(sample_size)
  for i in 0...sample_size
    loop {
      x = envelope_distribution.sample
      u = Kernel.rand(0)
      f_x = Math.exp(target_distribution.log_density(x))
      e_x = c * Math.exp(envelope_distribution.log_density(x))
      if (u <  f_x / e_x)
        draws[i] = x
        break
      end
    }
  end
  draws
end
