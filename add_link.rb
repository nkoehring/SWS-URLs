#!/usr/bin/ruby
# encoding: UTF-8

unless ARGV.length == 1
  puts "Usage: #{$0} link"
  exit 1
end

URL = ARGV[0].strip

# first check, if the link is already there
i = 0
File.foreach 'db' do |line|
  if URL == line.strip
    puts "#{URL} linked at\thttp://url.nkoehring.de/#{i.to_s(36)}"
    exit 0
  end
  i+=1
end

# no? so we add it
db = File.open('db', 'a')
db.write("#{URL}\n")
db.close
puts "#{URL} linked at\thttp://url.nkoehring.de/#{i.to_s(36)}"
exit 0

