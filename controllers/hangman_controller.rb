class HangmanController < ApplicationController

  get '/' do
    if game_in_progress = HangmanGame.find_by(user_id: current_user.id, game_completed: false)
      @game = game_in_progress
    else
      secret_word = HangmanGame.get_new_word(5)
      @game = HangmanGame.create({
        user_id: current_user.id,
        secret_word: secret_word,
        })
    end
    erb :'hangman/game'
  end

  post '/:id/guess' do
    content_type :json
    game = HangmanGame.find(params[:id])
    game.guess_letter(params[:guess])
    game.completed?
    {
      secret_word: game.secret_word, #this is definitely not necessary
      guessed_letters: game.guessed_letters, #this may not be necessary
      tries: game.tries,
      last_guess_correct: game.last_guess_correct,
      game_completed: game.game_completed,
      win: true,
      }.to_json
  end

end