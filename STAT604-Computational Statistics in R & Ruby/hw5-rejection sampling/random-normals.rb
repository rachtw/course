# Make available the things defined in 'distributions.rb' in the current
# working directory.
require './distributions'

require './normal'
require './logistic'

# Make available the method defined in 'rejection-sampler.rb' in the
# current working directory.
require './rejection-sampler'

# Let's try it out!
mean, variance = 3, 4
normal = Normal.new(mean,variance)
logistic = Logistic.new(mean,sqrt(variance))
#c =  normal.evaluate(normal.mode) / logistic.evaluate(logistic.mode)
c = Math.exp(normal.log_density(normal.mode)) / Math.exp(logistic.log_density(logistic.mode))
t = Time.new
draws = sample_via_rejection(normal,logistic,c,1000)
puts "%.6f" % (Time.new.to_f - t.to_f)

# Make availabe Dr. Dahl's extension which allows access for R within Ruby.
require 'dbd/R'

# Pass the Ruby variable 'draws' (defined above) to the R variable 'y'
$R.assign("y",draws)

# Make R run the following code.  Below we are constructing a multiline
# string using a 'here document' with embedded Ruby code (via the "#{}"
# technique).  See page 62 of the PixAxe book to learn about 'here documents'.
$R.eval <<EOF
  x <- seq(min(y)-1,max(y)+1,length=100)
  postscript("figure.ps",width=5.5,height=5)
  hist(y,freq=FALSE,xlim=c(min(y)-1,max(y)+1),ylim=c(0,#{normal.evaluate(normal.mode)}),
    main="Distribution of realizations and theoretical density")
  lines(x,dnorm(x,mean=#{mean},sd=#{sqrt(variance)}))
  lines(x,#{c}*dlogis(x,location=#{mean},scale=#{sqrt(variance)}),col="red")
  dev.off()
  # First, convert to 'encapsulated postscript', thus reducing the 'bounding box'
  system("ps2epsi figure.ps")
  # Second, convert it to a PDF file
  system("epstopdf figure.epsi")
  # Remove the encapsulated postscript and postscript files
  system("rm figure.epsi figure.ps")  
EOF
