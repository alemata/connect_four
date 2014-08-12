class Game < ActiveRecord::Base

  serialize :board

  NUM_ROWS = 6
  NUM_COLUMNS = 7

  belongs_to :player_1, :class_name => "User"
  belongs_to :player_2, :class_name => "User"
  belongs_to :current_player, :class_name => "User"

  validates :player_1, :player_2, :current_player, presence: true

  def initialize(attributes={})
    super
    self.status = :new
    self.player_1 = User.find_by(name: "User1")
    self.player_2 = User.find_by(name: "User2")
    self.current_player = self.player_1
    self.board = Array.new(NUM_ROWS){ Array.new(NUM_COLUMNS) {|i| :blank } }
  end

  def play(player, column)
    info = {played: false, win: false, tie: false}
    num_row = get_row(column)

    if num_row
      self.board[num_row][column] = color(player)
      win = check_board(color(player))
      if win
        self.status = :finished
      else
        self.current_player = next_player
      end
      played = true if self.save
      info[:played] = true
      info[:win] = win
    end

    info
  end

  def reset
    self.status = :new
    self.current_player = self.player_1
    self.board = Array.new(NUM_ROWS){ Array.new(NUM_COLUMNS) {|i| :blank } }
    self.save
  end

  def check_board(color)
    check_horizontal(color) || check_vertical(color) || check_diagonals(color)
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

  def check_horizontal(color)
    win = false
    (0..NUM_ROWS - 1).each do |row|
      break if win
      (0..3).each do |col|
        break if win
        if self.board[row][col] == color
          win = check_horizontal_line(color, row, col)
        end
      end
    end

    win
  end

  def check_horizontal_line(color, row, col)
    self.board[row][col] == color &&
      [self.board[row][col], self.board[row][col+1], self.board[row][col+2], self.board[row][col+3]].uniq.size == 1
  end

  def check_vertical(color)
    win = false
    (0..2).each do |row|
      break if win
      (0..NUM_COLUMNS - 1).each do |col|
        break if win
        if self.board[row][col] == color
          win = check_vertical_line(color, row, col)
        end
      end
    end

    win
  end

  def check_vertical_line(color, row, col)
    self.board[row][col] == color &&
      [self.board[row][col], self.board[row+1][col], self.board[row+2][col], self.board[row+3][col]].uniq.size == 1
  end

  def check_diagonals(color)
    win = false
    (0..2).each do |row|
      break if win
      (0..3).each do |col|
        break if win
        if self.board[row][col] == color
          win = check_diagonal_up_line(color, row, col)
        end
      end
    end

    5.downto(3).each do |row|
      break if win
      (0..3).each do |col|
        break if win
        if self.board[row][col] == color
          win = check_diagonal_down_line(color, row, col)
        end
      end
    end

    win
  end

  def check_diagonal_up_line(color, row, col)
    self.board[row][col] == color &&
      [self.board[row][col], self.board[row+1][col+1], self.board[row+2][col+2], self.board[row+3][col+3]].uniq.size == 1
  end

  def check_diagonal_down_line(color, row, col)
    self.board[row][col] == color &&
      [self.board[row][col], self.board[row-1][col+1], self.board[row-2][col+2], self.board[row-3][col+3]].uniq.size == 1
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
