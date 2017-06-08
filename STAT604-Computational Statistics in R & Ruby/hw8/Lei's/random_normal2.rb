require './distributions'
include Math

mu = 3
stand = 2
sample = Array.new(1000)

for i in 0...500
    u1=Uniform.new.sample
    u2=Uniform.new.sample
    sample[i]=stand*sqrt(-2*log(u1))*cos(2*PI*u2)+mu
    sample[i+500]=stand*sqrt(-2*log(u1))*sin(2*PI*u2)+mu
end

require 'dbd/R'

$R.assign("y",sample)
$R.eval <<EOF

pdf("figure.pdf")
x<-seq(-5,11,length=1000)
plot(density(y),main="kernel and theoretical density")
lines(x,dnorm(x,3,2),col="red")
dev.off()

EOF


