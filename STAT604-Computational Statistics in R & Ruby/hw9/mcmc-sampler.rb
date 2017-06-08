class ProposalDistribution

  # From the current state 'x', randomly generate a proposed state.
  def propose(x)
    raise "Not implemented"
  end

  # The proposal density at the current state 'x', evaluated at the proposal 'y'
  def log_proposal_density(y,x)
    raise "Not implemented"
  end

  # Is this proposal distribution symmetric?
  def symmetric?
    raise "Not implemented"
  end

end

class RandomWalk < ProposalDistribution

  def log_proposal_density(y,x)
    0.0
  end

  def symmetric?
    true
  end

end

class UnivariateUniformRandomWalk < RandomWalk

  def initialize(width,index=0)
    @width = width
    @index = index
  end
  
  # implemented only for testing
  #def log_proposal_density(y,x)
  #  if y[@index] <= x[@index] + @width/2 && y[@index] >= x[@index] - @width/2
  #    - Math.log(@width)
  #  else
  #    -1.0/0.0
  #  end
  #end
  
  # implemented only for testing
  #def symmetric?
  #  false
  #end  

  def propose(x)
    y = x.clone
    y[@index] = x[@index] + @width*(rand-0.5)
    y
  end

end

class BivariateNormalRandomWalk < RandomWalk

  require 'gsl'
  include Math
  include GSL::Sf

  def initialize(stdev1,stdev2,correlation,indices=[0,1])
    @stdev1 = stdev1.to_f
    @stdev2 = stdev2.to_f
    @correlation = correlation.to_f
    @indices = indices
  end

  # implemented only for testing
  #def log_proposal_density(y,x)
  #  z1 = (y[@indices[0]] - x[@indices[0]]) / @stdev1
  #  z2 = (y[@indices[1]] - x[@indices[1]]) / @stdev2
  #  - Math.log(2 * GSL::M_PI * @stdev1 * @stdev2 * Math.sqrt(1-@correlation**2)) - 
  #    (z1**2 - 2*@correlation*z1*z2 + z2**2) / 2 /(1-@correlation**2)
  #end

  # implemented only for testing
  #def symmetric?
  #  false
  #end  

  def propose(x)
    y = x.clone
    two_pi_r = 2*GSL::M_PI*rand
    sqrt_n2_ln_phi = Math.sqrt(-2*log(rand))
    z1 = cos(two_pi_r) * sqrt_n2_ln_phi
    z2 = sin(two_pi_r) * sqrt_n2_ln_phi
    c1 = sqrt(1.0+@correlation)/2.0
    c2 = sqrt(1.0-@correlation)/2.0
    y[@indices[0]] = x[@indices[0]] + @stdev1*(c1*z1+c2*z2)
    y[@indices[1]] = x[@indices[1]] + @stdev2*(c1*z1-c2*z2)
    y
  end

end

class Model

  # state: Array representing the current state
  # Returns the log of the (unnormalized) density
  def log_density(state)
    raise "Not implemented"
  end

end

# model: Object of a class derived from the 'Model' class
# initial_state: Array representing the initial state
# proposal_distributions: Objects of classes derived from the 'ProposalDistribution' class
# sample_size: Number of samples to draw
def sample_via_mcmc(model,initial_state,proposal_distributions,sample_size)
  draws = Array.new(sample_size)
  state = initial_state
  draws[0] = state.clone
  accept = 0
  for i in 1...sample_size
    for j in 0...(proposal_distributions.length)
      log_mh_ratio = -model.log_density(state)
      proposal = proposal_distributions[j].propose(state)
      log_mh_ratio += model.log_density(proposal)
      if ! proposal_distributions[j].symmetric?
        log_mh_ratio += proposal_distributions[j].log_proposal_density(state,proposal)
        log_mh_ratio -= proposal_distributions[j].log_proposal_density(proposal,state)
      end
      if Math.log(rand) < log_mh_ratio
        accept += 1
        state = proposal
      end
    end
    draws[i] = state.clone
  end
  [ draws, accept.to_f / ( sample_size * proposal_distributions.length ) ]
end

