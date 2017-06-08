x <- rnorm(20)
x

sort(x)

plot(ecdf(x))

z <- seq(-3,3,by=0.1)
lines(z,pnorm(z),col="red")

