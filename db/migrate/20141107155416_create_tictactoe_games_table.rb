class CreateTictactoeGamesTable < ActiveRecord::Migration
  def change
    create_table :tictactoe_games do |t|
      t.references    :user
      t.string        :x_moves,         :default => ''
      t.string        :o_moves,         :default => ''
      t.boolean       :game_completed,  :default => false
      t.boolean       :player1_turn,    :default => true
      t.string        :winner
      t.timestamps
    end
  end
end
