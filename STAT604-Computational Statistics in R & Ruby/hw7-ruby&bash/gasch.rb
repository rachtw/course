File.open(ARGV[0],"r") do |infile|
  File.open(ARGV[1],"w") do |outfile|
    infile.each_line do |line|
      if line =~ /^ /
        next
      elsif line == "\n"
        outfile.print "\n"
      elsif line =~ /^M/
        outfile.print "#{line.chop} "
      else
        outfile.print line.split(' ')[6]
      end
    end
  end
end
