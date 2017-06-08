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
end

def sample_via_importance(target_distribution, importance_distribution,
                          sample_size, standardize_weights=false)

   require 'gsl'
   include Math
   include GSL::Sf

   td = target_distribution
   id = importance_distribution

   draws = Array.new(sample_size)
   weights = Array.new(sample_size)

   for i in 0...sample_size
       draws[i] = id.sample

      begin 
        weights[i] = exp( td.log_density(draws[i]) - id.log_density(draws[i]))

      rescue GSL::ERROR::EUNDRFLW
        weights[i] = 0.0
      end

   end

 if standardize_weights
    sum = weights.inject  {|x, y| y+=x}
    weights.collect! { |x| sample_size*x/sum}
 end

results = [draws, weights]

results

end

