# == Description
# I modified the original[http://errtheblog.com/posts/89-huba-huba] to do a bit more. I work in different environments. Linux, Mac, and even Windows. I hate keeping track of all this dotfile nonsense so here is how my install script works.
# 
# 
# $ ./.install mac
# $ ./.install cygwin
# $ ./.install linux
# $ ./.install mac bashrc
# for help(not much): $ ./.install
# 
# Of course, these are all dependent on shell(I use bash) and setup and blah blah blah. But you can take this install script and win at life(computer life only) in any environment. To add a new environment just create a new folder and off you go. 
# 
# == Features
#  * multiple environments
#  * install single files
#  * support for config directories(.irssi for example)
# 
# == TODO
#   * be less lame
#   * named arguments?(--files=??)
#   * a common folder to guard against duplication(probably need to use named arguments)
#   * named arguments are so frustrating

#!/usr/bin/env ruby

# from http://errtheblog.com/posts/89-huba-huba

if ARGV[0].nil?
  puts "Here are your configs: #{Dir["*"].join(',')}"
  puts "usage: #{$0} CONFIG [FILE]"
  puts "want to see what's out there? me too: #{$0} --list"
  exit
elsif ARGV[0] == '--list'
  Dir['*'].each do |config|
    puts "#{config}:"
    Dir["#{config}/*"].each {|file| puts "  - #{File.split(file).last}"}
  end
  exit
end

home = File.expand_path('~')

Dir["#{ARGV[0]}/#{ARGV[1]||'*'}"].each do |file|
  target = File.join(home, ".#{File.split(file)[-1]}")
  `ln -f -h -s -i #{File.expand_path file} #{target}` # we need all these options (f and h) in order to prevent looped symlinks for dotdirectories
end

# git push on commit
`echo 'git push' > .git/hooks/post-commit`
`chmod 755 .git/hooks/post-commit`