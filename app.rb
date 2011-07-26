#!/usr/bin/ruby
# encoding: UTF-8

require "haml"
require "sass"
require "sinatra"

get "*.css" do
  sass params[:splat].join('/').to_sym
end

get "/" do
  @db = IO.readlines('db')
  @stats = begin
             Marshal.load(File.open("stats", "r"))
           rescue EOFError, Errno::ENOENT
             {}
           end

  haml :index
end

get "/:code" do
  # aw damn… there is no real point to optimise this
  code = params[:code]
  idx = params[:code].to_i(36)
  db = IO.readlines('db')
  @url = db[idx].strip
  return status 404 unless @url

  File.open("stats", File::RDWR|File::CREAT, 0644) do |f|
    f.flock(File::LOCK_EX)

    if f.size == 0
      stats = { code.to_sym => 1 }
    else
      stats = Marshal.load(f)
      f.rewind
      if stats.include? code.to_sym
        stats[code.to_sym] += 1
      else
        stats[code.to_sym] = 1
      end
    end

    Marshal.dump(stats, f)
    f.flush
    f.flock(File::LOCK_UN)
  end

  haml :url
end

