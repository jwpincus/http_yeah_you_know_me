require "minitest/autorun"
require 'minitest/pride'
require './lib/hello_world.rb'

class TestHelloWorld < Minitest::Test
  def test_it_exists
    assert HelloServer.new
  end

  def test_it_serves
    assert_instance_of TCPServer, HelloServer.start_server
  end
end