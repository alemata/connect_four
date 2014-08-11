class Game < ActiveRecord::Base

  serialize :board

  NUM_ROWS = 6
  NUM_COLUMNS = 7

  belongs_to :player_1, :class_name => "User"
  belongs_to :player_2, :class_name => "User"
  belongs_to :current_player, :class_name => "User"

  def initialize(attributes={})
    super
    self.status = :new
    self.player_1 = User.find_by(name: "User1")
    self.player_2 = User.find_by(name: "User2")
    self.current_player = self.player_1
    self.board = Array.new(NUM_ROWS){ Array.new(NUM_COLUMNS) {|i| :blank } }
  end

  def play(player, column)
    self.board[0][column] = color(player)
    self.current_player = next_player
    self.save
  end

  private

  def color(player)
    if player == self.player_1
      :red
    elsif player == self.player_2
      :blue
    end
    #TODO raise error
  end

  def next_player
    if self.current_player == self.player_1
      self.player_2
    elsif self.current_player == self.player_2
      self.player_1
    end
  end

end
