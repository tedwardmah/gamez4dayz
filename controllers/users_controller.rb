class UsersController < ApplicationController

  get '/' do
    @users = User.all
    erb :'users/index'
  end

  get '/new' do
    erb :'users/new'
  end

  post '/' do
    new_user = User.new(params[:user])
    new_user.password = params[:password]
    new_user.save!
    redirect '/users'
  end

  get '/:id/edit' do
    # TO DO
    erb :'users/edit'
  end

  patch '/:id' do
    # TO DO
  end

  get '/:id' do
    if page_belongs_to_current_user?(params[:id])
      erb :'users/profile'
    end
  end

  delete '/:id' do
    # TO DO
  end

end