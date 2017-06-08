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