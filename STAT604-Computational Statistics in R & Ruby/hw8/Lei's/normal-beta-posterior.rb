require './distributions'
require 'gsl'
include Math
include GSL::Sf

class NormalBetaPosterior < Beta

  def initialize(alpha,beta,x)
      super(alpha,beta)
      @x=x.collect! {|n| n.to_f}
  end

  def log_density(u)
    if in_support?(u)
       sum=0.0
       super-0.5 * @x.inject {|sum, i| sum+(i-u)**2}
    else
       @@NegativeInfinity
    end
  end

  def support
   [0.0,1.0]
  end
end
