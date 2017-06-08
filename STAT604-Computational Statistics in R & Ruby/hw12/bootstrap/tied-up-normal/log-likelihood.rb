class LogLikelihood
  
  require 'gsl'   # Why here and not outside the class definition?
  include Math

  # Constructor accepting the data
  def initialize(data)
    @data = data
    @n = data.length.to_f
  end

  # Get the sample size
  def sample_size
    @n
  end

  attr_reader :data

#  # Not necessary because of attr_reader above
#  def data
#    @data
#  end

  attr_accessor :parameter

#  # Not necessary because of attr_accessor above
#  # Get the parameter value
#  def parameter
#    @parameter
#  end
#
#  # Not necessary because of attr_accessor above
#  # Set the parameter value
#  def parameter=(value)
#    @parameter = value
#  end

  # Log-likelihood function, returned as a Float
  def logL
    raise "No implemented"
  end

  # Gradient of the log-likelihood, returned as a GSL::Vector
  def d1logL
    raise "No implemented"
  end

  # Hessian of the log-likelihood, returned as a GSL::Matrix
  def d2logL
    raise "No implemented"
  end

end
