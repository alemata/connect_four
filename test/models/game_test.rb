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

  test "change turn when player moves" do
    @game.play(users(:user_one), 0)

    assert_equal users(:user_two), @game.current_player, "Error when changing turn when player moves"
  end


  # Check boards statuses

  test "check no win when no played" do
    assert_not @game.check_board(:red), "Error detecting not winner"
  end

  test "check no win when played" do
    @game.board[0][0] = :red
    @game.board[0][1] = :red
    @game.board[0][2] = :red

    assert_not @game.check_board(:red), "Error detecting not winner"
  end

  test "check no win when played 2" do
    @game.board[0][0] = :red
    @game.board[0][1] = :red
    @game.board[0][2] = :red
    @game.board[0][3] = :blue

    assert_not @game.check_board(:red), "Error detecting not winner"
  end

  # Horizontal win

  test "check horizontal win" do
    @game.board[0][0] = :red
    @game.board[0][1] = :red
    @game.board[0][2] = :red
    @game.board[0][3] = :red

    assert @game.check_board(:red), "Error detecting horizontal win"
  end

  test "check horizontal win 2" do
    @game.board[0][3] = :red
    @game.board[0][4] = :red
    @game.board[0][5] = :red
    @game.board[0][6] = :red

    assert @game.check_board(:red), "Error detecting horizontal win"
  end

  # Vertical win

  test "check vertical win" do
    @game.board[0][3] = :red
    @game.board[1][3] = :red
    @game.board[2][3] = :red
    @game.board[3][3] = :red

    assert @game.check_board(:red), "Error detecting vertical win"
  end

  test "check vertical win 2" do
    @game.board[2][2] = :red
    @game.board[3][2] = :red
    @game.board[4][2] = :red
    @game.board[5][2] = :red

    assert @game.check_board(:red), "Error detecting vertical win"
  end

  # Diagonal win

  test "check diagonal win" do
    @game.board[0][0] = :red
    @game.board[1][1] = :red
    @game.board[2][2] = :red
    @game.board[3][3] = :red

    assert @game.check_board(:red), "Error detecting diagonal win"
  end

end
