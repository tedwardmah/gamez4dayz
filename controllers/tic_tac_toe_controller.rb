class TicTacToeController < ApplicationController

  before do
    authenticate!
  end

  get '/' do
    if game_in_progress = TictactoeGame.find_by(user_id: current_user.id, game_completed: false)
      @game = game_in_progress
    else
      @game = TictactoeGame.create({
        user_id: current_user.id
        })
    end
    @game_display = @game.render_board_display
    erb :'games/tictactoe'
  end

  post '/:id/move' do
    content_type :json
    game = TictactoeGame.find(params[:id])
    game.make_move(params[:space_num])
    game.check_win
    {
      new_board_state: game.board_state,
      game_completed: game.game_completed,
      winner: game.winner,
      player1_turn: game.player1_turn,
      }.to_json
  end

end