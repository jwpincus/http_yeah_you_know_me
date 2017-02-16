require "minitest/autorun"
require 'minitest/pride'
require 'faraday'
require './lib/http'   
require 'pry-state' 

class TestServer < Minitest::Test
  def setup
    @conn = Faraday.new 'http://127.0.0.1:9292/'
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

  i_suck_and_my_tests_are_order_dependent!


  def test_it_exists
    assert_instance_of Server, Server.new
  end

  def test_request_lines_parse
    parsed_lines = Server.new.parse_request_lines(@request_lines)
    assert_equal parsed_lines["Verb"], "GET"
    assert_equal parsed_lines["Path"], "/"
    assert_equal parsed_lines["Protocol"], "HTTP/1.1"
    assert_equal parsed_lines["Host"], " 127.0.0.1:9292"
    assert_equal parsed_lines["Accept"], " */*"
  end

  def test_a_hello_once
    conn = @conn.get '/hello'
    assert_equal "<html><head></head><body><h1>Hello World!(1)</h1></body></html>", conn.body.split('<pre>')[0]
  end

  def test_b_hello_counter
    conn = @conn.get '/hello'
    assert_equal "<html><head></head><body><h1>Hello World!(2)</h1></body></html>", conn.body.split('<pre>')[0]
  end

  def test_date_time
    conn = @conn.get '/datetime'
    assert_equal "<html><head></head><body><h1>#{Time.now.strftime('%H:%M:%S on %a, %e %b %Y ')}</h1></body></html>", conn.body.split('<pre>')[0]
  end

  def test_start_new_game
    conn = @conn.get '/start_game'
    assert_equal "<html><head></head><body><h1>Good Luck!</h1></body></html>", conn.body.split('<pre>')[0]
  end

  def test_play_a_game
    conn = @conn.get '/game'
    assert_equal "<html><head></head><body><h1>No guesses made yet</h1></body></html>", conn.body.split('<pre>')[0]
    conn = @conn.post '/game', {:guess => 101}
    assert_equal true, conn.body.split('<pre>')[0].include?("101")
    assert_equal true, conn.body.split('<pre>')[0].include?("guesses have been made and the most recent guess (101) was too high")
    conn = @conn.post '/game', {:guess => -1}
    assert_equal true, conn.body.split('<pre>')[0].include?("-1")
    assert_equal true, conn.body.split('<pre>')[0].include?("guesses have been made and the most recent guess (-1) was too low")
    conn = @conn.get '/start_game'
    conn = @conn.get '/game'
    assert_equal "<html><head></head><body><h1>No guesses made yet</h1></body></html>", conn.body.split('<pre>')[0]
  end

  def test_z_shutdown
    conn = @conn.get '/shutdown'
    assert_equal true, conn.body.split('<pre>')[0].include?("<html><head></head><body><h1>Total Requests:")
  end
end