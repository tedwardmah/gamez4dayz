class CreatePlaysTable < ActiveRecord::Migration
  def change
    create_table :plays do |t|
      t.references :user
      t.references :tictactoe_game
      t.integer    :opponent_id
      t.boolean    :is_player_1
      t.boolean    :win,            :default => false
      t.timestamps
    end
  end
end
