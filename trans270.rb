#! /usr/bin/ruby

# trans270.rb

# Fri Aug  1 19:59:27 JST 2014 by hohno

line = 0
array = []
fontsize = 1

while (str = STDIN.gets)

  if (str =~ /^#/)
    # STDERR.puts str
    next
  end

  str.chomp!

  array[line % fontsize] = str.split(" ")
  if (line == 0)
    fontsize = array[0].size
  end

  line += 1

  if ((line % fontsize) == 0)
    # b =  array.map(&:reverse).transpose.transpose
    b =  array.transpose.map(&:reverse)
    for x in 0..(fontsize-1) do
      puts b[x].join
   end 
  end

end
