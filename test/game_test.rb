require "minitest/autorun"
require './lib/game'
require 'minitest/pride'

class TestGame < Minitest::Test

  def test_it_exists
    assert_instance_of Game, Game.new
  end
  
  def test_game
    test_game = Game.new
    test_game.number_to_guess = 3
    assert_equal "No guesses made yet", test_game.game("GET", "")
    assert_equal "1 guesses have been made and the most recent guess (5) was too high", test_game.game("GET", "guess=5")
  end
end