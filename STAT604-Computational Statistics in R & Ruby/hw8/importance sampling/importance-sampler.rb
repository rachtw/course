# A method taking the following arguments:
#     target_distribution: an object of class Distribution
#     importance_distribution: an object of class SamplableDistribution
#     sample_size: an object of class Fixnum (i.e., an integer)
#     standardize_weights: true/false: weights should sum to sample_size?
# The method returns an array of length two containing the following two arrays:
#     1st element: An array of 'sample_size' Floats containing the actual draws
#     2nd element: An array of 'sample_size' Floats containing the importance
#                  weights associated with the draws
def sample_via_importance(target_distribution,importance_distribution,
                          sample_size,standardize_weights=false)
  ##
  ## Your code goes here.
  ##
  require 'gsl'
  include GSL::Sf
  
  draws = Array.new(sample_size)
  weights = Array.new(sample_size)
  for i in 0...sample_size
    x = importance_distribution.sample
    draws[i] = x
    
    begin
      f_x = exp(target_distribution.log_density(x))
    rescue GSL::ERROR::EUNDRFLW
      f_x = 0
    end
    
    begin
      g_x = exp(importance_distribution.log_density(x))
    rescue GSL::ERROR::EUNDRFLW
      redo
    end
    
    if standardize_weights 
      weights[i] = f_x / g_x / sample_size
    else
      weights[i] = f_x / g_x
    end
  end
  [draws,weights]
end
