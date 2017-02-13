require "minitest/autorun"
require 'minitest/pride'
require 'faraday'
#require './lib/hello_world.rb'    

class TestHelloWorld < Minitest::Test
  def test_it_exists
    #assert HelloServer.new
  end

  def test_it_serves_hello_world
    response = Faraday.get 'http://127.0.0.1:9292'
    assert_equal "<html><head></head><body><h1>Hello World!(1)</></body></html>", response.body
  end

  def test_it_increments_the_counter

  response = Faraday.get 'http://127.0.0.1:9292'
  assert_equal "<html><head></head><body><h1>Hello World!(2)</></body></html>", response.body
end
end