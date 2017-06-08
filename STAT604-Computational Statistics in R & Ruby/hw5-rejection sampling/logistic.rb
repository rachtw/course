# A subclass of the class 'SamplableDistribution' representing the logistic
# distribution.
class Logistic < SamplableDistribution

  def initialize(mu=0.0,s=1.0)
    @mu = mu.to_f
    @s = s.to_f
  end

  def evaluate(x)
    exp( -(x - @mu) / @s ) / ( @s * (( 1 + exp(-(x - @mu) / @s) ) ** 2) )
  end
  
  def log_density(x)
    #-log( @s ) - 2
    -log( @s ) - 2 * log( 1 + exp(-(x - @mu) / @s) ) - ((x - @mu) / @s)
  end

  def support
    [@@NegativeInfinity, @@PositiveInfinity]
  end

  def mode
    @mu
  end

  def sample
    p = Kernel.rand(0)
    @mu + @s * log( p / (1-p) )
  end

end
