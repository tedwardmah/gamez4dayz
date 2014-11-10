class ApplicationController < Sinatra::Base

  helpers AuthenticationHelper

  enable :sessions
  enable :method_override

  register Sinatra::ActiveRecordExtension

  set :database, {adapter: "postgresql", database: "gamez4dayz"}
  set :root, File.expand_path("../../", __FILE__)


  get '/' do
    erb :index
  end

  get '/games' do
    erb :games
  end

  get '/console' do
    binding.pry
  end

end