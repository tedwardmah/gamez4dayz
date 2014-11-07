class TictactoeGame < ActiveRecord::Base
  belongs_to :user

  def check_win(players_moves)
    player_combo = players_moves.chars.sort.join
    winning_combos = ["012", "345", "678", "036", "147", "258", "048", "246"]
    winning_combos.each do |winning_combo|
      if player_combo.scan(/#{winning_combo[0]}\d*#{winning_combo[1]}\d*#{winning_combo[2]}/).count > 0
        self.update({
          win: true
          })
      end
    end
  end

  def render_board_display
    board_display = self.board_state
    self.x_moves.chars.each do |space_number|
      board_display.gsub!(space_number, "X")
    end
    self.o_moves.chars.each do |space_number|
      board_display.gsub!(space_number, "O")
    end
    board_display.chars.each_slice(3).map{|x| x}
  end

  def make_move(space_num)
    if player1_turn
      self.update({
        x_moves: (self.x_moves + space_num.to_s),
        player1_turn: false,
        })
    else
      self.update({
        o_moves: (self.o_moves + space_num.to_s),
        player1_turn: true,
        })
    end
  end

end