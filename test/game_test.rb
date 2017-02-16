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
    assert_equal "<html><head></head><body><h1>No guesses made yet</h1></body></html>", test_game.game("GET", "")
    assert_equal "<html><head></head><body><h1>1 guesses have been made and the most recent guess (5) was too high</h1></body></html>", test_game.game("GET", "guess=5")
  end
end