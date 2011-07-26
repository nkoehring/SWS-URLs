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
  haml :index
end

get "/:code" do
  # aw damn… there is no real point to optimise this
  idx = params[:code].to_i(36)
  db = IO.readlines('db')
  @url = db[idx].strip

  if @url
    haml :url
  else
    status 404
  end
end

