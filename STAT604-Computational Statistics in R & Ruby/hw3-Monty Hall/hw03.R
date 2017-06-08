# Number of experiments
blocksize=125000

# The door which hides the prize
prize <- sample(3,blocksize,replace=TRUE)

# The beginning choice of door made by the contestant
contestant.choice <- sample(3,blocksize,replace=TRUE)

# The result of strategy 1 - don't switch the door
dontswitch.win <- prize==contestant.choice

# The result of strategy 2 - switch the door
switch.win <- prize!=contestant.choice

# The statistics
dontswitch.mu <- mean(dontswitch.win)
dontswitch.sigma2 <- var(dontswitch.win) 
dontswitch.sigma <- sqrt(dontswitch.sigma2)
dontswitch.ci <- dontswitch.mu + c(-1,1) * 1.96 * sqrt(dontswitch.sigma2 / blocksize)

dontswitch.mu
dontswitch.sigma
dontswitch.ci

switch.mu <- mean(switch.win)
switch.sigma2 <- var(switch.win) 
switch.sigma <- sqrt(switch.sigma2)
switch.ci <- switch.mu + c(-1,1) * 1.96 * sqrt(switch.sigma2 / blocksize)

switch.mu
switch.sigma
switch.ci

########################################
# Basically, the simulation is done by the above code.
# The following gives the choices made using the two strategies 
# and the door opened by the host, but they don't affect
# the statistics.
########################################

# Since the contestant uses "don't switch" strategy, his/her choice remains the same as at the beginning
dontswitch.choice <- contestant.choice

# Create an array to hold the choice made by the contestant using "switch" strategy
switch.choice <- integer(blocksize)

# Create an array to hold the choice made by the host
host.choice <- integer(blocksize)

for (i in 1:blocksize) {
	# Initialize the variable x with three doors
	x <- (1:3)

	# Remove the door which hides the prize
	x <- x[x!=prize[i]]

	# Remove the door which the contestant chose at the beginning
	x <- x[x!=contestant.choice[i]]

	# If only one door is left
	if (length(x) == 1) {
		# The host must pick this door
		host.choice[i] <- x

		# The contestant which switches the door must pick the door of prize
		switch.choice[i] <- prize[i]
	} 
	# Otherwise, two doors are left for the host to pick
	else {
		# Assume the host randomly chooses one door out of the two
		choice.between.2 <- sample(2,1)
		host.choice[i] <- x[choice.between.2]

		# The contestant which switches the door must pick the other one
		switch.choice[i] <- x[3 - choice.between.2]
	}
}

# Take a look at the first ten trials
print(prize[1:10])
print(host.choice[1:10])
print(switch.choice[1:10])
