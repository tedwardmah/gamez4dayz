class HangmanGame < ActiveRecord::Base
  belongs_to :user

  before_create :assign_secret_word

  def assign_secret_word
    self.secret_word ||= new_word
  end


  def display_word
    display_word = self.secret_word
    #array of guessed letters
    guessed_letters = self.guessed_letters.chars
    #array of letters that appear in the word but have not been guessed
    unrevealed_letters = self.secret_word.chars - guessed_letters

    unrevealed_letters.each do |letter|
      display_word.gsub!(letter, "_")
    end
    display_word
  end

  def guess_letter(guess)
    # is the letter guessed already?
    if self.guessed_letters.include?(guess)
      self.update({
        tries: (self.tries - 1),
        last_guess_correct: false,
        })
    else # add the letter to guessed letters...
      new_guessed_letters = self.guessed_letters + guess
      self.update({guessed_letters: new_guessed_letters})
      # ...and check to see if the guess is in the word
      if self.secret_word.include?(guess)
        self.update({
          last_guess_correct: true,
          })
      else
        self.update({
          tries: (self.tries - 1),
          last_guess_correct: false,
          })
      end
    end
    self.completed?
  end

  def completed?
    unrevealed_letters = self.secret_word.chars - self.guessed_letters.chars
    # test for win
    if unrevealed_letters.empty?
      self.update({
        win: true,
        game_completed: true,
        })
    # test for loss
    elsif self.tries == 0
      self.update({
        game_completed: true,
        })
    end
  end

  private

  def new_word(word_length=14)
    pattern = /^.{5,#{word_length}}$/
    File.foreach('models/wordz.txt').grep(pattern).sample.downcase.chomp
  end

end