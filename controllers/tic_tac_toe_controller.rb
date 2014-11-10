class TicTacToeController < ApplicationController

  before do
    authenticate!
  end

  get '/' do
    @games = TictactoeGame.where(game_completed: false)
    erb :'games/tictactoe/lobbies'
  end

  get '/new' do
    if !current_user.has_unmatched_ttt_game?
      game = TictactoeGame.create({
        user_id: current_user.id,
        })
      player1_play = Play.create({
        user_id: current_user.id,
        tictactoe_game_id: game.id,
        is_player_1: true,
        })
      redirect "/tictactoe/users/#{current_user.id}"
    else
      redirect "/tictactoe/users/#{current_user.id}"
    end
  end

  get '/replay' do
    last_game = TictactoeGame.find(params[:last_game_id].to_i)
    last_opponent = last_game.opponent(current_user.id)
    if !current_user.has_current_ttt_game_with?(last_opponent)
      new_player1 = last_game.player2
      new_player2 = last_game.player1
      game = TictactoeGame.create({
        user_id: new_player1.id
        })
      player1_play = Play.create({
        user_id: new_player1.id,
        opponent_id: new_player2.id,
        tictactoe_game_id: game.id,
        is_player_1: true,
        })
      player2_play = Play.create({
        user_id: new_player2.id,
        opponent_id: new_player1.id,
        tictactoe_game_id: game.id,
        is_player_1: false,
        })
      redirect "/tictactoe/#{game.id}"
    else
      current_game = current_user.current_ttt_game_with(last_opponent)
      redirect "/tictactoe/#{current_game.id}"
    end
  end

  get '/users/:user_id' do
    user = User.find(params[:user_id])
    @plays = user.plays
    erb :'games/tictactoe/user_games'
  end

  get '/join/:id' do
    game = TictactoeGame.find(params[:id])
    if current_user.has_current_ttt_game_with?(game.user)
      current_game = current_user.current_ttt_game_with(game.user)
      redirect "/tictactoe/#{current_game.id}"
    elsif !game.matched? #prevents players from joining a game that is already matched or a second game with a given user
      player1_play = game.plays.first
      player1_play.update({
        opponent_id: current_user.id,
        })
      player2_play = Play.create({
        user_id: current_user.id,
        opponent_id: game.user.id,
        tictactoe_game_id: game.id,
        is_player_1: false,
        })
      redirect "/tictactoe/#{game.id}"
    else
      redirect '/tictactoe'
    end
  end

  get '/:id/gamestate' do
    content_type :json
    game = TictactoeGame.find(params[:id])
    winning_spaces = game.get_winning_spaces if game.game_completed
    {
      new_board_state: game.board_state,
      game_completed: game.game_completed,
      winner: game.winner,
      player1_turn: game.player1_turn,
      winning_spaces: winning_spaces,
      }.to_json
  end

  get '/:id' do
    @game = TictactoeGame.find(params[:id])
    if @game.game_completed
      redirect "/tictactoe"
    else
      @game_display = @game.render_board_display
      erb :'games/tictactoe/tictactoe'
    end
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