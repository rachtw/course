module DBD
module Broccoli
module Integration
module MonteCarlo

  def quantile(lower_tail_area,draws)
    Tools.find_root_via_midpoints(draws.min,draws.max) { |x|
      percentile(x,draws) - lower_tail_area
    }
  end

  def interval(coverage,draws)
    [ quantile((1-coverage)/2.0,draws), quantile(1-(1-coverage)/2.0,draws) ]
  end

  def median(draws)
    quantile(0.5,draws)
  end

  def mean(draws)
    integrate(draws) { |d|
      d
    }
  end

  def variance(draws)
    eX2 = integrate(draws) { |d|
      d**2
    }
    eX = mean(draws)
    eX2 - eX*eX
  end

  def stdev(draws)
    Math.sqrt(variance(draws))
  end

  def percentile(x,draws)
    p1 = integrate(draws) { |d|
      ( d <= x ) ? 1 : 0
    }
    p2 = 1 - integrate(draws) { |d|
      ( d >= x ) ? 1 : 0
    }
    avg_p = ( p1 + p2 ) / 2
    avg_p = 1.0 if x > draws.max
    avg_p = 0.0 if x < draws.min
    [ [ avg_p, 1.0 ].min, 0.0 ].max
  end

  def integrate(draws)
    sum = 0.0
    draws.each_index { |i| sum += yield(draws[i]) }
    sum.to_f / draws.length
  end

  module_function :quantile, :interval, :median, :mean, :variance, :stdev, :percentile, :integrate

end
end
end
end
