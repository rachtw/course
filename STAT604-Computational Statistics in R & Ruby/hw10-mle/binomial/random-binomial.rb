def random_binomial(n_trials,p)
  y = 0 # number of successes
  for i in 1..n_trials
    u = Kernel.rand(0)
    if u <= p
      y=y+1
    end
  end
  y
end