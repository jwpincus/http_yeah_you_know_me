
require_relative 'game'
require_relative 'word_search'
require 'pry'
class Path
  def initialize
    @hit_counter = 0
    @game = Game.new
    @word = WordSearch.new
  end
  
  def path_dependent_output(path, verb = "GET", body = nil)
    @hit_counter += 1
    case path
    when "/"
      return nil
    when "/hello"
      return "<html><head></head><body><h1>Hello World!(#{@hit_counter})</h1></body></html>"
    when "/datetime"
      Time.now.strftime('%H:%M:%S on %a, %e %b %Y ')
    when "/start_game"
      @game = Game.new
      "Good Luck!"
    when "/game"
      @game.game(verb, body)
    when "/shutdown"
      "<html><head></head><body><h1>Total Requests: #{@hit_counter}</h1></body></html>"
    else
      @word.word_search(path)
    end
  end

end



