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
    played = false
    num_row = get_row(column)
    if num_row
      self.board[num_row][column] = color(player)
      self.current_player = next_player
      played = true if self.save
    end

    played
  end

  def reset
    self.current_player = self.player_1
    self.board = Array.new(NUM_ROWS){ Array.new(NUM_COLUMNS) {|i| :blank } }
    self.save
  end

  private

  def get_row(column)
    num_row = nil
    (0..NUM_ROWS - 1).each do |row|
      if self.board[row][column] == :blank
        num_row = row
        break
      end
    end

    num_row
  end


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
