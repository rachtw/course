dir <- "../../../delivery/grid/whole/globins"

doit <- function(x) {
  result <- 0
  for ( i in 1:(length(x)-1) ) {
    result <- result + as.numeric(system(paste("distance ",dir,"/tor-pos_",x[i],".grid ",dir,"/tor-pos_",x[i+1],".grid",sep=""),intern=TRUE))
  }
  return(result/(length(x)-1))
}

maxpos <- 181
t.obs <- doit(1:maxpos)
print(t.obs)

t.null <- numeric(100)
for ( i in 1:length(t.null) ) {
  t.null[i] <- doit(sample(1:maxpos))
  print(t.null[i])
}

sum(t.null <= t.obs)


