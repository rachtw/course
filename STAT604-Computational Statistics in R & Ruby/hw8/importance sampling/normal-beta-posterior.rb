class NormalBetaPosterior < Beta

  def initialize(alpha=1,beta=1,x=nil)
    super(alpha,beta)
    @x = x
  end

  def log_density(u)
    if in_support?(u)
      sum = 0.0
      @x.each_index { |i| sum += (@x[i] - u) ** 2 }    
      (@alpha-1) * log(u) + (@beta-1) * log(1-u) - (sum.to_f / 2)
    else
      @@NegativeInfinity
    end
  end
  
end