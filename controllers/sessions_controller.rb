class SessionsController < ApplicationController

  get '/new' do
    if params[:try_again]
      @tryagain = true
    end
    erb :'sessions/new'
  end

  post '/' do
    user = User.find_by(username: params[:username])
    if user && user.password == params[:password]
      session[:current_user] = user.id
      redirect "/users/#{user.id}"
    else
      redirect "/sessions/new?try_again='true'"
    end
  end

  delete '/' do
    session[:current_user] = nil
    redirect '/users'
  end

end