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
end

