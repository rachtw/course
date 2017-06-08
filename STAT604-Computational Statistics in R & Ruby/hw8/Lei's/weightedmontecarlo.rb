module DBD
module Broccoli
module Integration
module WeightedMonteCarlo

  def quantile(lower_tail_area,draws,weights=nil)
    Tools.find_root_via_midpoints(draws.min,draws.max) { |x|
      percentile(x,draws,weights) - lower_tail_area
    }
  end

  def interval(coverage,draws,weights=nil)
    [ quantile((1-coverage)/2.0,draws,weights), quantile(1-(1-coverage)/2.0,draws,weights) ]
  end

  def median(draws,weights=nil)
    quantile(0.5,draws,weights)
  end

  def mean(draws,weights=nil)
    integrate(draws,weights) { |d|
      d
    }
  end

  def variance(draws,weights=nil)
    eX2 = integrate(draws,weights) { |d|
      d**2
    }
    eX = mean(draws,weights)
    eX2 - eX*eX
  end

  def stdev(draws,weights=nil)
    Math.sqrt(variance(draws,weights))
  end

  def percentile(x,draws,weights=nil)
    p1 = integrate(draws,weights) { |d|
      ( d <= x ) ? 1 : 0
    }
    p2 = 1 - integrate(draws,weights) { |d|
      ( d >= x ) ? 1 : 0
    }
    avg_p = ( p1 + p2 ) / 2
    avg_p = 1.0 if x > draws.max
    avg_p = 0.0 if x < draws.min
    [ [ avg_p, 1.0 ].min, 0.0 ].max
  end

  def integrate(draws,weights=nil)
    sum = 0.0
    if weights==nil
    draws.each_index { |i| sum += yield(draws[i]) }
    sum.to_f / draws.length
    else
    draws.each_index { |i| sum += yield(draws[i])*weights[i] }
    sum.to_f / draws.length
    end
 end
  module_function :quantile, :interval, :median, :mean, :variance, :stdev, :percentile, :integrate

end
end
end
end
