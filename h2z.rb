#! /usr/bin/ruby

require "moji"

while str = STDIN.gets
  print Moji.han_to_zen(str)
end
