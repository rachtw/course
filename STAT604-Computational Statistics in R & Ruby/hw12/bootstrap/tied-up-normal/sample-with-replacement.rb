# This method selects a random sample with replacement from an Array of data.
# The size of the resulting sample defaults to the size of the original dataset.
def sample_with_replacement(data,size=data.length)
  sample_data = Array.new(size)
  n = data.length
  for i in 0...n
    sample_data[i] = data[(rand*n).to_i]
  end
  sample_data
end
