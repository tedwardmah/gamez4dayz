class HangmanController < ApplicationController

  before do
    authenticate!
  end

  get '/' do
    if game_in_progress = HangmanGame.find_by(user_id: current_user.id, game_completed: false)
      @game = game_in_progress
    else
      @game = HangmanGame.create({
        user_id: current_user.id,
        })
    end
    erb :'/games/hangman'
  end

  post '/:id/guess' do
    content_type :json
    game = HangmanGame.find(params[:id])
    if page_belongs_to_current_user?(game.user_id)
      game.guess_letter(params[:guess])
      word_display = game.game_completed ? game.secret_word : game.display_word
      {
        new_display: word_display,
        tries: game.tries,
        last_guess_correct: game.last_guess_correct, #i think this is unnecessary
        game_completed: game.game_completed,
        win: game.win,
        guessed_letters: game.guessed_letters,
        }.to_json
    end
  end

end