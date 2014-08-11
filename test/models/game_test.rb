require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "new game is valid" do
    assert games(:game_one).valid?, "No valid new game"
  end
end
