require "minitest/autorun"
require './lib/path_output'
require 'minitest/pride'

class TestPath < Minitest::Test

  def test_it_exists
    assert_instance_of Path, Path.new
  end
  
  def test_path_dependent_output
    assert_equal  "<html><head></head><body><h1>Hello World!(1)</h1></body></html>",Path.new.path_dependent_output("/hello")
    assert_equal  Time.now.strftime('%H:%M:%S on %a, %e %b %Y '),Path.new.path_dependent_output("/datetime")
    assert_equal "<html><head></head><body><h1>Total Requests: 1</h1></body></html>", 
  end
  
end