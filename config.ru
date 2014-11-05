require 'bundler'
Bundler.require(:default)

require './helpers/authentication_helper'
require './controllers/application_controller'

Dir.glob('./{helpers,models,controllers}/*.rb').each do |file|
  require file
  puts "required #{ file }"
end

map('/users'){ run UsersController }
map('/sessions'){ run SessionsController }
map('/'){ run ApplicationController }