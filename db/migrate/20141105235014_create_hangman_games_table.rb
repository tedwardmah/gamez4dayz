class CreateHangmanGamesTable < ActiveRecord::Migration
  def change
    create_table :hangman_games do |t|
      t.references    :user
      t.string        :secret_word
      t.string        :guessed_letters,   :default => ''
      t.integer       :tries,             :default => 6
      t.boolean       :last_guess_correct
      t.boolean       :win,               :default => false
      t.boolean       :game_completed,    :default => false
      t.timestamps
    end
  end
end
