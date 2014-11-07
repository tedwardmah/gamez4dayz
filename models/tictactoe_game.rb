class TictactoeGame < ActiveRecord::Base
  belongs_to :user

  def check_win
    player_combo = self.player1_turn ? o_moves.chars.sort.join : x_moves.chars.sort.join
    winning_combos = ["012", "345", "678", "036", "147", "258", "048", "246"]
    win = winning_combos.any? do |combo|
      player_combo.scan(/#{combo[0]}\d*#{combo[1]}\d*#{combo[2]}/).count > 0
    end
    if win
      winner = self.player1_turn ? "O" : "X"
      self.update({
        game_completed: true,
        winner: winner,
        })
    end
  end

  def render_board_display
    self.board_state.chars.each_slice(3).map{|x| x}
  end

  def make_move(space_num)
    if player1_turn
      self.update({
        board_state: (self.board_state.gsub(space_num, "X")),
        x_moves: (self.x_moves + space_num.to_s),
        player1_turn: false,
        })
    else
      self.update({
        board_state: (self.board_state.gsub(space_num, "O")),
        o_moves: (self.o_moves + space_num.to_s),
        player1_turn: true,
        })
    end
  end

end