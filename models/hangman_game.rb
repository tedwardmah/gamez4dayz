class HangmanGame < ActiveRecord::Base
  belongs_to :user

  def self.get_new_word(word_length)
    full_word_list = File.read(File.dirname(__FILE__) + '/wordz.txt')
    regexp = '\b\w{' + word_length.to_s + '}\b'
    full_word_list.scan(Regexp.new(regexp)).sample
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
    display_word.chars.join(' ')
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

end