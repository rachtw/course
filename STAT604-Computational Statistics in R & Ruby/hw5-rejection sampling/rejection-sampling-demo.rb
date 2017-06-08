# Make available the things defined in 'distributions.rb' in the current
# working directory.
require './distributions'

# Make available the method defined in 'rejection-sampler.rb' in the
# current working directory.
require './rejection-sampler'

# Let's try it out!
alpha1, alpha2 = 5, 2
beta = Beta.new(alpha1,alpha2)
c =  Math.exp(beta.log_density(beta.mode))
#c = beta.evaluate(beta.mode)
draws = sample_via_rejection(beta,Uniform.new,c,10000)

# Graphically check our realization from the beta distribution.

# Make availabe Dr. Dahl's extension which allows access for R within Ruby.
require 'dbd/R'

# Pass the Ruby variable 'draws' (defined above) to the R variable 'y'
$R.assign("y",draws)

# Make R run the following code.  Below we are constructing a multiline
# string using a 'here document' with embedded Ruby code (via the "#{}"
# technique).  See page 62 of the PixAxe book to learn about 'here documents'.
$R.eval <<EOF
  x <- seq(0,1,length=100)
  postscript("beta.ps",width=5.5,height=5)
  hist(y,freq=FALSE,xlim=c(0,1),ylim=c(0,exp(#{beta.log_density(beta.mode)})),
    main="Distribution of realizations and theoretical density")
  lines(x,dbeta(x,#{alpha1},#{alpha2}))
  lines(x,#{c}*dunif(x),col="red")
  dev.off()
  # First, convert to 'encapsulated postscript', thus reducing the 'bounding box'
  system("ps2epsi beta.ps")
  # Second, convert it to a PDF file
  system("epstopdf beta.epsi")
  # Remove the encapsulated postscript and postscript files
  system("rm beta.epsi beta.ps")  
EOF

# In case this script was run not run in irb (rather, ruby itself), pause
# before ending the script.
print "Press <enter> to exit."
$stdout.flush
gets

