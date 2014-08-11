class Game < ActiveRecord::Base

  serialize :board

  NUM_ROWS = 6
  NUM_COLUMNS = 7

  belongs_to :player_1, :class_name => "User"
  belongs_to :player_2, :class_name => "User"

  def initialize(attributes={})
    super
    self.status = :new
    self.player_1 = User.find_by(name: "User1")
    self.player_2 = User.find_by(name: "User2")
    self.board = Array.new(NUM_ROWS){ Array.new(NUM_COLUMNS) {|i| :blank } }
  end

end
