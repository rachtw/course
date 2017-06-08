require './distributions'
require './normal-beta-posterior'
require './logistic'
require './importance-sampler'
require 'dbd/broccoli'

data_string = <<-EOF
1.256221800  0.126891641  0.731333995  1.44110535
0.920214895  0.288621683  0.938422666 -0.03042552
0.825395421 -0.235645910  0.221364993  2.39934747
0.001389487  0.728429034  1.879146415  0.90488844
EOF
data = data_string.split.collect { |x| x.to_f }

alpha1, alpha2 = 5, 3
location, scale = 0.65, 0.1
results = sample_via_importance(NormalBetaPosterior.new(alpha1,alpha2,data),Logistic.new(location,scale),10000)
draws,weights = results[0],results[1]

include DBD::Broccoli::Integration::WeightedMonteCarlo

puts mean(draws,weights)
puts interval(0.95,draws,weights)






