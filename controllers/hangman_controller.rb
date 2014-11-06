class HangmanController < ApplicationController

  get '/' do
    if game_in_progress = HangmanGame.find_by(user_id: current_user.id, game_completed: false)
      @game = game_in_progress
    else
      @game = HangmanGame.create({
        user_id: current_user.id,
        })
    end
    erb :'hangman/game'
  end

  post '/:id/guess' do
    content_type :json
    game = HangmanGame.find(params[:id])
    game.guess_letter(params[:guess])
    word_display = game.game_completed ? game.secret_word : game.display_word
    {
      new_display: word_display,
      guessed_letters: game.guessed_letters, #this may not be necessary
      tries: game.tries,
      last_guess_correct: game.last_guess_correct,
      game_completed: game.game_completed,
      win: true,
      }.to_json
  end

end