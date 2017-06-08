require 'log-likelihood'

class LogisticRegression < LogLikelihood

  # Override the constructor in the super class (i.e., 'LogLikelihood')
  # @data = # of successes = y (length n)
  # @predictor = x (length n)
  # @n_trials = # of trials (length n)
  # @parameter = beta (length 2) ([intercept=beta0, slope=beta1])
  
  def initialize(data,predictor,n_trials)
    super(data)   # Put data into an array for capatibility with
                    # the super class and call the super class'
                    # constructor.
    @predictor  = predictor 
    @n_trials = n_trials
  end

  def logL
    sum = 0.0
    for i in 0..@n-1
      exponent = @parameter[0]+@predictor[i]*@parameter[1]
      sum += -@data[i] * log(1.0 + Math.exp(-exponent)) -
             (@n_trials[i]-@data[i]) * log(1.0 + Math.exp(exponent))
    end
    sum
  end

  # First derivative of log likelihood, returned as a GSL::Vector
  def d1logL
    sum0 = 0.0
    for i in 0..@n-1
      exponent = @parameter[0]+@predictor[i]*@parameter[1]
      sum0 += @data[i] * 1.0 / (1.0 + Math.exp(exponent)) -
              (@n_trials[i]-@data[i]) * 1.0 /(1.0 + Math.exp(-exponent))
    end
    sum1 = 0.0
    for i in 0..@n-1
      exponent = @parameter[0]+@predictor[i]*@parameter[1]
      sum1 += @data[i] * @predictor[i] / (1.0 + Math.exp(exponent)) -
              (@n_trials[i]-@data[i]) * @predictor[i]  / (1.0 + Math.exp(-exponent))
    end
    GSL::Vector.alloc([sum0,sum1])
  end

  # Second derivative of log likelihood, returned as a GSL::Matrix
  def d2logL
    sum00 = 0.0
    for i in 0..@n-1
      exponent = @parameter[0]+@predictor[i]*@parameter[1]
      sum00 += - @data[i] * 1.0 * 1.0 * Math.exp(exponent) / ((1.0 + Math.exp(exponent)) ** 2) -
              (@n_trials[i]-@data[i]) * 1.0 * 1.0 * Math.exp(-exponent) / ((1.0 + Math.exp(-exponent)) ** 2)
    end
    sum01 = 0.0
    for i in 0..@n-1
      exponent = @parameter[0]+@predictor[i]*@parameter[1]
      sum01 += - @data[i] * 1.0 * @predictor[i] * Math.exp(exponent) / ((1.0 + Math.exp(exponent)) ** 2) -
              (@n_trials[i]-@data[i]) * 1.0 * @predictor[i] * Math.exp(-exponent) / ((1.0 + Math.exp(-exponent)) ** 2)
    end
    sum10 = 0.0
    for i in 0..@n-1
      exponent = @parameter[0]+@predictor[i]*@parameter[1]
      sum10 += - @data[i] * @predictor[i] * 1.0 * Math.exp(exponent) / ((1.0 + Math.exp(exponent)) ** 2) -
              (@n_trials[i]-@data[i]) * @predictor[i] * 1.0 * Math.exp(-exponent) / ((1.0 + Math.exp(-exponent)) ** 2)
    end
    sum11 = 0.0
    for i in 0..@n-1
      exponent = @parameter[0]+@predictor[i]*@parameter[1]
      sum11 += - @data[i] * @predictor[i] * @predictor[i] * Math.exp(exponent) / ((1.0 + Math.exp(exponent)) ** 2) -
              (@n_trials[i]-@data[i]) * @predictor[i] * @predictor[i] * Math.exp(-exponent) / ((1.0 + Math.exp(-exponent)) ** 2)
    end
    GSL::Matrix.alloc([sum00,sum01,sum10,sum11],2,2)
  end

end
