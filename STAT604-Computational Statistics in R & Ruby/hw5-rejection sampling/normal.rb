# A subclass of the class 'Distribution' representing the normal distribution.
class Normal < Distribution

  def initialize(mean=0.0,variance=1.0)
    @mean = mean.to_f
    @variance = variance.to_f
  end

  def evaluate(x)
    1 / (sqrt( 2 * PI * @variance )) * exp( - ((x - @mean) ** 2) / (2 * @variance) )
  end
  
  def log_density(x)
    #- log( @variance * sqrt(2 * E * PI) )
    -log( sqrt(2 * PI * @variance) ) - ((x - @mean) ** 2) / (2 * @variance)
  end

  def support
    [@@NegativeInfinity, @@PositiveInfinity]
  end

  def mode
    @mean
  end

end
