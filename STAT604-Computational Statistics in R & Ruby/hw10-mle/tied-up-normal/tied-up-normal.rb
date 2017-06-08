require 'log-likelihood'

class TiedUpNormal < LogLikelihood

  # Override the set in the base class
  def parameter=(value)
    super # Call this method in the super class (i.e., 'LogLikelihood')
    @parameter = GSL::Vector.alloc([ 0.0, @parameter[0] ].max)
    @sumy  = 0.0
    @sumy2 = 0.0
    @data.each_index { |i| @sumy  += (@data[i]-@parameter[0])    }
    @data.each_index { |i| @sumy2 += (@data[i]-@parameter[0])**2 }
  end

  # Log-likelihood
  def logL
    -@n/2.0*log(2*Math::PI) - @n/2.0*log(@parameter[0]) - 1.0/2.0*@parameter[0]**(-1)*@sumy2
  end

  # First derivative of log-likelihood
  def d1logL
    GSL::Vector.alloc([-@n/2.0*@parameter[0]**(-1) + 1.0/2.0*@parameter[0]**(-2)*@sumy2 + @parameter[0]**(-1)*@sumy])
  end

  # Second derivative of log-likelihood
  def d2logL
    GSL::Matrix.alloc([-@n*@parameter[0]**(-1)+(-2.0*@sumy+@n/2.0)*@parameter[0]**(-2) - @parameter[0]**(-3)*@sumy2],1,1)
  end

end
