require "minitest/autorun"
require 'minitest/pride'
require 'faraday'
require './lib/iteration_3.rb'    

class TestHelloWorld < Minitest::Test
  def setup
    @request_lines = ["GET / HTTP/1.1",
 "Host: 127.0.0.1:9292",
 "Connection: keep-alive",
 "Cache-Control: no-cache",
 "Save-Data: on",
 "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36",
 "Postman-Token: 05413677-0fd5-f9ca-6b66-b78d2d734371",
 "Accept: */*",
 "Accept-Encoding: gzip, deflate, sdch, br",
 "Accept-Language: en-US,en;q=0.8"]
  end

  def test_it_exists
    assert Server.new
  end

  def test_request_lines_parse
    parsed_lines = Server.new.parse_request_lines(@request_lines)
    assert_equal parsed_lines["Verb"], "GET"
    assert_equal parsed_lines["Path"], "/"
    assert_equal parsed_lines["Protocol"], "HTTP/1.1"
    assert_equal parsed_lines["Host"], " 127.0.0.1:9292"
    assert_equal parsed_lines["Accept"], " */*"
  end

  def test_path_dependent_output
    assert_equal  "<html><head></head><body><h1>Hello World!(1)</h1></body></html>",Server.new.path_dependent_output("/hello")
    assert_equal  Time.now.strftime('%H:%M:%S on %a, %e %b %Y '),Server.new.path_dependent_output("/datetime")
    assert_equal "<html><head></head><body><h1>Total Requests: 1</h1></body></html>", Server.new.path_dependent_output("/shutdown")
  end

  def test_word_search
    assert_equal "<html><head></head><body><h1>xylophone is a known word</h1></body></html>", Server.new.path_dependent_output("/word_search?word=xylophone")
    assert_equal "<html><head></head><body><h1>xart is an unknown word</h1></body></html>", Server.new.path_dependent_output("/word_search?word=xart")
  end
end