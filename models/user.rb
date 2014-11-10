class User < ActiveRecord::Base
  include BCrypt

  validates :username, :password_hash, :email, presence: true
  validates :username, uniqueness: true

  has_many :hangman_games
  has_many :plays
  has_many :tictactoe_games, :through => :plays

  def password
    @password ||= Password.new(self.password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def has_current_ttt_game_with?(opponent)
    has_current_game = false
    current_players_open_games = self.tictactoe_games.where(game_completed: false)
    current_players_open_games.each do |game|
      game_exists = game.plays.any? do |play|
        play.opponent_id == opponent.id
      end
      has_current_game = true if game_exists
    end
    has_current_game
  end

  def current_ttt_game_with(opponent)
    current_game = nil
    current_players_open_games = self.tictactoe_games.where(game_completed: false)
    current_players_open_games.each do |game|
      if game.plays.any? {|play| play.opponent_id == opponent.id}
        current_game = game
      end
    end
    current_game
  end

end