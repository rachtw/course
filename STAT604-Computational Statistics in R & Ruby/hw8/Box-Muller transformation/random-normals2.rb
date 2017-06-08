def random_normal(sample_size,mean,variance)

  draws = Array.new(sample_size)
  
  include Math

  sigma = sqrt(variance)
  
  for i in 0...sample_size
    next if (i%2 == 1) 
    
    u1 = Kernel.rand(0)
    u2 = Kernel.rand(0)
    
    v1 = 2*u1-1
    v2 = 2*u2-1
    s = v1 ** 2 + v2 ** 2
    
    redo if (s > 1)
    
    draws[i] = sqrt(-2 * log(s) / s) * v1 * sigma + mean
    
    # if sample_size is an odd number, the following statement
    # will not be executed at the last run of the loop
    if ((i+1)<sample_size)
      draws[i+1] = sqrt(-2 * log(s) / s) * v2 * sigma + mean
    end
  end
  
  draws
end

mean, variance = 3, 4
t = Time.new
draws = BoxMullerTransformation(mean,variance,1000)
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
  plot(density(y),type="l",
  main=paste("Normally distributed random numbers; mean=",#{mean},", var=",#{variance}))
  lines(x,dnorm(x,mean=#{mean},sd=#{sqrt(variance)}),col="red")
  dev.off()
  # First, convert to 'encapsulated postscript', thus reducing the 'bounding box'
  system("ps2epsi figure.ps")
  # Second, convert it to a PDF file
  system("epstopdf figure.epsi")
  # Remove the encapsulated postscript and postscript files
  system("rm figure.epsi figure.ps")  
EOF

# In case this script was run not run in irb (rather, ruby itself), pause
# before ending the script.
print "Press <enter> to exit."
$stdout.flush
gets
