# Representation of a generic probability distribution of a continous random
# variable.
class Distribution

  # Make the GNU Scientific Library (GSL) available
  require 'gsl'

  # Make the methods in the module Math available to this class without
  # having to preface them everytime.  For example to call the square root
  # method 'Math::sqrt', in this class we just need to write 'sqrt'.
  include Math

  # Make the methods in the module GSL::Sf available to this class without
  # having to preface them everytime.  In the case that the modules Math and
  # GSL::Sf defined methods with the same name, GSL::Sf takes precedence
  # since it is included after Math.
  include GSL::Sf

  # Define the class constant.  It pertains to the class (instead of an
  # instance of the class) because it has two '@' (instead of only one '@').
  # It is a constant because is name starts with a capital letter.
  @@NegativeInfinity = -1.0/0.0
  @@PositiveInfinity =  1.0/0.0
  
  def evaluate(x)
    raise "Not implemented"
  end

  # Log of the probability density function evaluated at 'x'.
  def log_density(x)
    raise "Not implemented"
  end

  # Returns an array of length 2 containing the smallest and largest values
  # that the random variable can take.
  def support
    raise "Not implemented"
  end

  # Is this 'x' within the support of the distribution?
  def in_support?(x)
    return true if support[0] <= x && x <= support[1]
    false
  end

  # Returns the mode of the distribution.
  def mode
    raise "Not implemented"
  end

end



# A subclass of the class 'Distribution'.  All of the (public) methods and
# variables of 'Distribution' are available to 'SamplableDistribution'.
class SamplableDistribution < Distribution

  # Returns a realization of the random variable.
  def sample
    raise "Not implemented"
  end

end



# A subclass of the class 'SamplableDistribution' representing the uniform
# distribution.
class Uniform < SamplableDistribution

  def initialize(min=0.0,max=1.0)
    @min = min.to_f
    @max = max.to_f
    @range = @max - @min
  end

  def evaluate(x)
    if in_support?(x)
      1 / (@max - @min)
    else
      0
    end
  end
  
  def log_density(x)
    if in_support?(x)
      -log( @range )
    else
      @@NegativeInfinity
    end
  end

  def support
    [@min, @max]
  end

  def mode
    0.0
  end

  def sample
    @min + rand * @range
  end

end



# A subclass of the class 'Distribution' representing the beta distribution.
class Beta < Distribution

  def initialize(alpha=1,beta=1)
    @alpha = alpha.to_f
    @beta = beta.to_f
  end
  
  def evaluate(x)
    if in_support?(x)
      ( x ** (@alpha - 1)) * ( (1-x) ** (@beta - 1) ) / beta(@alpha,@beta)
    else
      0
    end
  end

  def log_density(x)
    if in_support?(x)
      -lnbeta(@alpha,@beta) + (@alpha-1) * log(x) + (@beta-1) * log(1-x)
    else
      @@NegativeInfinity
    end
  end

  def support
    [0.0, 1.0]
  end

  def mode
    ( @alpha - 1 ) / ( @alpha + @beta - 2 )
  end

end
