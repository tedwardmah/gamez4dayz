class TicTacToeController < ApplicationController

  before do
    authenticate!
  end

  get '/' do
    erb :'games/tictactoe'
  end

end