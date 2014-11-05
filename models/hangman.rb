class Hangman
  attr_reader :last_guess_correct, :tries, :winner
  def initialize(word_length)
    @secret_word = get_new_word(word_length)
    @unrevealed_letters = @secret_word.chars
    @guessed_letters = []
    @last_guess_correct = false
    @tries = 5
    @winner = false
  end

  def get_new_word(word_length)
    full_word_list = File.read(File.dirname(__FILE__) + '/wordz.txt')
    regexp = '\b\w{' + word_length.to_s + '}\b'
    full_word_list.scan(Regexp.new(regexp)).sample
  end

  def display_word
    display_word = @secret_word.chars.join
    @unrevealed_letters.each do |letter|
      display_word.gsub!(letter, " _")
    end
    display_word
  end

  def guess_letter(guess)
    @guessed_letters << guess.downcase if !@guessed_letters.include?(guess.downcase)
    if @unrevealed_letters.include?(guess.downcase)
      @unrevealed_letters.reject! { |letter| letter == guess.downcase }
      @last_guess_correct = true
    else
      @tries -= 1
      @last_guess_correct = false
    end
  end

  def game_won?
      @winner = true if @unrevealed_letters.empty?
  end

end



# puts "*******************"
# puts "Welcome to Hangman!"
# puts "*******************\n\n"
# # new game setup
# puts "How long a word would you like to guess?"
# user_word_length = gets.chomp
# hangman = Hangman.new(user_word_length)
# while hangman.tries != 0 && !hangman.winner
#   puts hangman.display_word
#   puts "\n"
#   puts (hangman.tries.to_s + " tries remaining...\n\n")
#   puts "Guess a letter:"
#   guess = gets.chomp
#   hangman.guess_letter(guess)
#   if hangman.last_guess_correct
#     puts "Good guess!\n"
#   else
#     puts "You suck!\n"
#   end
#   hangman.game_won?
# end

# if hangman.winner
#   puts "You win!"
# else
#   puts "You lose...but at least justice was served to a dirty criminal"
# end