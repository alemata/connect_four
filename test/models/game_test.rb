require 'test_helper'

class GameTest < ActiveSupport::TestCase

  def setup
    @game =  Game.create
    @game.player_1 = users(:user_one)
    @game.player_2 = users(:user_two)
    @game.current_player = users(:user_one)
  end

  test "new game is valid" do
    assert games(:game_one).valid?, "No valid new game"
  end

  test "next row is 0 when no played" do
    (0..Game::NUM_COLUMNS - 1).each do |col|
      assert_equal 0, @game.send(:get_row, col)
    end
  end

  test "next row is 1 when played one in column 0" do
    @game.play(users(:user_one), 0)

    assert_equal 1, @game.send(:get_row, 0), "Error on played column"


    (1..Game::NUM_COLUMNS - 1).each do |col|
      assert_equal 0, @game.send(:get_row, col), "Error on no played column"
    end
  end

  test "next row is 2 when played one in column 0 two times" do
    @game.play(users(:user_one), 0)
    @game.play(users(:user_two), 0)

    assert_equal 2, @game.send(:get_row, 0), "Error on played column"

    (1..Game::NUM_COLUMNS - 1).each do |col|
      assert_equal 0, @game.send(:get_row, col), "Error on no played column"
    end
  end
  

end
