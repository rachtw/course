iris <- read.table("iris.txt",header=TRUE)

# The means of sepal length, sepal width, petal length and petal width
mean(iris$Sepal.Length)
mean(iris$Sepal.Width)
mean(iris$Petal.Length)
mean(iris$Petal.Width)

interval <- numeric(nlevels(iris$Species))

# Relative fequency for the sepal length data

# Choose number of bins
# The data in each class are divided into at least log2(class size) bins

trange <- tapply(iris$Sepal.Length, iris$Species, range)
tlength <- tapply(iris$Sepal.Length, iris$Species, length)
numbin <- round( log2( tlength[1] ) )
interval[1] <- round( (diff(trange$setosa) + 0.1) / numbin, 1)
numbin <- round( log2( tlength[2] ) )
interval[2] <- round( (diff(trange$versicolor) + 0.1) / numbin, 1)
numbin <- round( log2( tlength[3] ) )
interval[3] <- round( (diff(trange$virginica) + 0.1) / numbin, 1)

# Use the smallest interval calculated

mininterval <- min(interval)
r <- range(iris$Sepal.Length)
numbin <- ceiling( (diff(r) + 0.1) / mininterval)
data <- cut( iris$Sepal.Length, breaks = r[1] - 0.1 + mininterval * (0:numbin) )
table(data, iris$Species)


# Relative fequency for the sepal width data <= WRONG!!! It's frequency not relative frequency

# Choose number of bins
# The data in each class are divided into at least log2(class size) bins

trange <- tapply(iris$Sepal.Width, iris$Species, range)
tlength <- tapply(iris$Sepal.Width, iris$Species, length)
numbin <- round( log2( tlength[1] ) )
interval[1] <- round( (diff(trange$setosa) + 0.1) / numbin, 1)
numbin <- round( log2( tlength[2] ) )
interval[2] <- round( (diff(trange$versicolor) + 0.1) / numbin, 1)
numbin <- round( log2( tlength[3] ) )
interval[3] <- round( (diff(trange$virginica) + 0.1) / numbin, 1)

# Use the smallest interval calculated

mininterval <- min(interval)
r <- range(iris$Sepal.Width)
numbin <- ceiling( (diff(r) + 0.1) / mininterval)
data <- cut( iris$Sepal.Width, breaks = r[1] - 0.1 + mininterval * (0:numbin) )
table(data, iris$Species)


# Relative fequency for the petal length data

# Choose number of bins
# The data in each class are divided into at least log2(class size) bins

trange <- tapply(iris$Petal.Length, iris$Species, range)
tlength <- tapply(iris$Petal.Length, iris$Species, length)
numbin <- round( log2( tlength[1] ) )
interval[1] <- round( (diff(trange$setosa) + 0.1) / numbin, 1)
numbin <- round( log2( tlength[2] ) )
interval[2] <- round( (diff(trange$versicolor) + 0.1) / numbin, 1)
numbin <- round( log2( tlength[3] ) )
interval[3] <- round( (diff(trange$virginica) + 0.1) / numbin, 1)

# Use the smallest interval calculated

mininterval <- min(interval)
r <- range(iris$Petal.Length)
numbin <- ceiling( (diff(r) + 0.1) / mininterval)
data <- cut( iris$Petal.Length, breaks = r[1] - 0.1 + mininterval * (0:numbin) )
table(data, iris$Species)


# Relative fequency for the petal width data

# Choose number of bins
# The data in each class are divided into at least log2(class size) bins

trange <- tapply(iris$Petal.Width, iris$Species, range)
tlength <- tapply(iris$Petal.Width, iris$Species, length)
numbin <- round( log2( tlength[1] ) )
interval[1] <- round( (diff(trange$setosa) + 0.1) / numbin, 1)
numbin <- round( log2( tlength[2] ) )
interval[2] <- round( (diff(trange$versicolor) + 0.1) / numbin, 1)
numbin <- round( log2( tlength[3] ) )
interval[3] <- round( (diff(trange$virginica) + 0.1) / numbin, 1)

# Use the smallest interval calculated

mininterval <- min(interval)
r <- range(iris$Petal.Width)
numbin <- ceiling( (diff(r) + 0.1) / mininterval)
data <- cut( iris$Petal.Width, breaks = r[1] - 0.1 + mininterval * (0:numbin) )
table(data, iris$Species)


# A scatter plot (as a PDF) of the sepal width and length,
# using a different color for the plotting symbol of each species

# Define the color for each class
color <- character(nrow(iris))
color[iris$Species == "setosa"]     <- "red"
color[iris$Species == "versicolor"] <- "blue"
color[iris$Species == "virginica"]  <- "green"

# Write to the PDF file
pdf("iris.pdf",width=5.5,height=5)
plot(iris$Sepal.Length, iris$Sepal.Width, xlab="Sepal Length", ylab="Sepal Width", main="Iris Data", sub="Setosa: red; Versicolor: blue; Virginica: green", col=color)
dev.off()