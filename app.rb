require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"

require_relative "cookbook"
require_relative "recipe"

get "/" do
  @cookbook = Cookbook.new(File.join(__dir__, "recipes.csv"))
  @recipes = @cookbook.all
  erb :index
end

get "/new" do
  erb :new
end

get "/about" do
  erb :about
end

# [...]

get "/team/:username" do
  # binding.pry
  puts params[:username]
  "The username is #{params[:username]}"
end
