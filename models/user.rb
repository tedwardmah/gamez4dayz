class User < ActiveRecord::Base
  include BCrypt

  validates :username, :password_hash, :email, presence: true
  validates :username, uniqueness: true

  has_many :hangman_games
  has_many :tictactoe_games

  def password
    @password ||= Password.new(self.password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

end