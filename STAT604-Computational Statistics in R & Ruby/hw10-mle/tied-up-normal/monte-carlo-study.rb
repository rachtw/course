require 'tied-up-normal'
require 'mle-via-newton'
require 'random-normals2'

parameter = [ 1.0, 5.0 ]
sample_size = [ 10 ]
n_reps = 1000

require 'dbd/R'
require 'dbd/broccoli'
include DBD::Broccoli::Tools

def plot_it(logLikelihood)
  estimate = logLikelihood.parameter[0]
  x = seq(0.2,3.0,0.01)
  y = Array.new(x.length)
  x.each_index { |i|
    logLikelihood.parameter = GSL::Vector.alloc([x[i]])
    y[i] = logLikelihood.logL
  }
  $R.assign("x",x)
  $R.assign("y",y)
  $R.eval <<-EOF
    plot(x,y,type="l")
    abline(v=#{estimate})
    locator(1)
  EOF
end

#PLOT_IT = true
PLOT_IT = false

for theta in parameter
  for n in sample_size
    sum = 0.0
    sum2 = 0.0
    for rep in 0...n_reps
      # data = random_normal(n,theta,Math.sqrt(theta))
      data = random_normal(n,theta,theta)
      tied_up_normal = TiedUpNormal.new(data)
      begin
        #mle_via_newton(tied_up_normal,GSL::Vector.alloc([theta/2.0]))
        mle_via_newton(tied_up_normal,GSL::Vector.alloc([data.inject {|s,x| s += x}/data.length]))
        sum  += tied_up_normal.parameter[0]
        sum2 += tied_up_normal.parameter[0]**2
      rescue StandardError => msg
        puts msg
      end
      plot_it(tied_up_normal) if $PLOT_IT
    end
    bias = sum / n_reps - theta
    stderr = Math.sqrt( ( sum2 - sum**2/n_reps ) / ( n_reps - 1.0 ) / n_reps )
    ci_lower = bias - 1.96 * stderr 
    ci_upper = bias + 1.96 * stderr 
    puts "True parameter:            #{theta}"
    puts "Estimated bias and 95% CI: #{bias} (#{ci_lower}, #{ci_upper})"
  end
end

