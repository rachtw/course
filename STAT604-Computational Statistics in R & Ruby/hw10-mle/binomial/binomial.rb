require 'log-likelihood'

class Binomial < LogLikelihood

  # Override the constructor in the super class (i.e., 'LogLikelihood')
  def initialize(data,n_trials)
    super([data])   # Put data into an array for capatibility with
                    # the super class and call the super class'
                    # constructor.
    @n = n_trials   # Although we put data into an array of length 1,
                    # the sample size (i.e., number of trials) is
                    # is not one, but the 'n_trials' that was passed
                    # to the method.
  end

  def logL
    @data[0] * log(@parameter[0]) + (@n - @data[0]) * log(1.0-@parameter[0])
  end

  # First derivative of log likelihood, returned as a GSL::Vector
  def d1logL
    GSL::Vector.alloc([@data[0]/@parameter[0] - (@n - @data[0])/(1.0-@parameter[0])])
  end

  # Second derivative of log likelihood, returned as a GSL::Matrix
  def d2logL
    GSL::Matrix.alloc([-@data[0]/@parameter[0]**2 - (@n - @data[0])/(1.0-@parameter[0])**2],1,1)
  end

end
