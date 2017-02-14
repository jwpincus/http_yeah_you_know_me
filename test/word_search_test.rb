require "minitest/autorun"
require './lib/word_search'
require 'minitest/pride'

class TestWordSearch < Minitest::Test

  def test_it_exists
    assert_instance_of WordSearch, WordSearch.new
  end
  
  def test_word_search
    assert_equal "<html><head></head><body><h1>Xylophone is a known word</h1></body></html>", WordSearch.new.word_search("/word_search?word=xylophone")
    assert_equal "<html><head></head><body><h1>Xart is an unknown word</h1></body></html>", WordSearch.new.word_search("/word_search?word=xart")
  end
end