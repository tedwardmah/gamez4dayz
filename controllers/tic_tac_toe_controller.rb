class TicTacToeController < ApplicationController

  before do
    authenticate!
  end

  get '/' do
    #list all tictactoe games

    redirect '/'
  end

  get '/new' do
    game = TictactoeGame.create({
      user_id: current_user.id,
      })
    player1_play = Play.create({
      user_id: current_user.id,
      tictactoe_game_id: game.id,
      is_player_1: true,
      })
    redirect "/tictactoe/users/#{current_user.id}"
  end

  get '/users/:user_id' do
    user = User.find(params[:user_id])
    @plays = user.plays
    binding.pry
    erb :'games/tictactoe/user_games'
  end

  get '/:id' do
    @game = TictactoeGame.find(params[:id])
    @game_display = @game.render_board_display
    erb :'games/tictactoe/tictactoe'
  end

  post '/:id/move' do
    content_type :json
    game = TictactoeGame.find(params[:id])
    game.make_move(params[:space_num])
    game.check_game_over
    winning_spaces = game.get_winning_spaces if game.game_completed
    {
      new_board_state: game.board_state,
      game_completed: game.game_completed,
      winner: game.winner,
      player1_turn: game.player1_turn,
      winning_spaces: winning_spaces
      }.to_json
  end

end