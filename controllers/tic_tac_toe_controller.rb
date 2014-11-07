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
    binding.pry
    @game_display = @game.render_board_display
    erb :'games/tictactoe'
  end

  get '/:id/move' do
    content_type :json
    game = TictactoeGame.find(params[:id])


    {
      game_id: game.id
      }.to_json
  end

end