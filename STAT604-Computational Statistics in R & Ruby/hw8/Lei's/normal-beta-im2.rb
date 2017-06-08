require './distributions'
require './importance-sampler'
require './weightedmontecarlo'
require 'logistic'
require 'dbd/broccoli'
require 'normal-beta-posterior'
alpha1,alpha2=5,3

data_string=<<-EOF
1.256221800  0.126891641  0.731333995  1.44110535
0.920214895  0.288621683  0.938422666 -0.03042552
0.825395421 -0.235645910  0.221364993  2.39934747
0.001389487  0.728429034  1.879146415  0.90488844
EOF

data=data_string.split.collect {|x| x.to_f}

normalbeta=NormalBetaPosterior.new(alpha1,alpha2,data)
logistic=Logistic.new(0,1)

input=sample_via_importance(normalbeta,logistic,10000,true)
draws=input[0]
weights=input[1]

sum=0.0
draws.each_index {|i| sum += draws[i] * weights[i]}
mean1=sum.to_f/draws.length
puts mean1

include DBD::Broccoli::Integration::WeightedMonteCarlo

mean2=integrate(draws,weights) { |x| x}
puts mean2

raise"Notequal!" if mean1 !=mean2

mean3=mean(draws,weights)
puts mean3

raise "Not equal!" if mean2 !=mean3

puts interval(0.95,draws,weights)
