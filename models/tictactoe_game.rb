class TictactoeGame < ActiveRecord::Base
  belongs_to :user

  def check_win(player_combo)
    win = false
    player_combo = player_combo.chars.sort.join
    winning_combos = ["012", "345", "678", "036", "147", "258", "048", "246"]
    winning_combos.each do |winning_combo|
      if player_combo.scan(/#{winning_combo[0]}\d*#{winning_combo[1]}\d*#{winning_combo[2]}/).count > 0
        win = true
      end
    end
    win
  end

end