require "minitest/autorun"
require './lib/path_output'
require 'minitest/pride'

class TestPath < Minitest::Test

  def test_it_exists
    assert_instance_of Path, Path.new
  end
  
  def test_hello
    assert_equal  "<html><head></head><body><h1>Hello World!(1)</h1></body></html>",Path.new.path_dependent_output("/hello")
  end

  def test_datetime
    assert_equal  Time.now.strftime('%H:%M:%S on %a, %e %b %Y '),Path.new.path_dependent_output("/datetime")
  end

  def test_shutdown
    assert_equal "<html><head></head><body><h1>Total Requests: 1</h1></body></html>", Path.new.path_dependent_output("/shutdown")
  end

  def test_404
    assert_equal  "<html><head></head><body><h1>Response Code: 404 Not Found (1)</h1></body></html>",Path.new.path_dependent_output("/giberish")
  end
  
end