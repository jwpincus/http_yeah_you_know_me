require 'socket' 
require 'pry-state'
class Server
  attr_accessor :hit_counter,
                :guessed_number,
                :number_to_guess
  def initialize
    @hit_counter = 0
    @server = true
    @guess_counter = 0
    @number_to_guess = (0..100).to_a.shuffle.first
    @guessed_number = nil
  end
  
  def start_server
      Socket.tcp_server_loop(9292) do |server, address|
          request_lines = []
          while line = server.gets and !line.chomp.empty?
            request_lines << line.chomp
          end
          
          hashed_lines = parse_request_lines(request_lines)
          body = server.read(hashed_lines['Content-Length'].to_i)
          response = path_dependent_output(hashed_lines['Path'], hashed_lines['Verb'], body)
          pre = pre_format(hashed_lines)
          server.print response
          server.print pre
          server.close
          break if hashed_lines['Path'] == "/shutdown"
        end
  end

  def parse_request_lines(request_lines)
    hashed = {}
    request_lines.each do |line|
      if !line.include?(":")
        hashed = parse_verb_path_protocol(line).merge(hashed)
      else
        line = line.split(":", 2)
        hashed[line[0]] = line[1]
      end
    end
    hashed
  end

  def parse_verb_path_protocol(line)
      first_line_hash = {}
      line = line.split(" ", 3)
      first_line_hash["Verb"] = line[0]
      first_line_hash["Path"] = line[1]
      first_line_hash["Protocol"] = line[2]
      first_line_hash
  end

  def pre_format(hashed_lines)
    "<pre>
    Verb: #{hashed_lines['Verb']}
    Path: #{hashed_lines['Path']}
    Protocol: #{hashed_lines['Protocol']}
    Host: #{hashed_lines['Host']}
    Origin: 127.0.0.1
    Accept: #{hashed_lines["Accept"]}
    </pre>"
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
      "Good Luck!"
    when "/game"
      game(verb, body)
    when "/shutdown"
      "<html><head></head><body><h1>Total Requests: #{@hit_counter}</h1></body></html>"
    else
      word_search(path)
    end
  end

  def word_search(path)
    word = path.split('=')[-1]
    dictionary = File.open('./data/all_words.txt').read
    if dictionary.include? "\n#{word}\n"
      "<html><head></head><body><h1>#{word.capitalize} is a known word</h1></body></html>"
    else
      "<html><head></head><body><h1>#{word.capitalize} is an unknown word</h1></body></html>"
    end
  end

  def game(verb, body = nil)
    guess = body.split("=").last.to_i if !body.empty?
    if guess
      @guess_counter += 1
      @guessed_number = guess
      "#{@guess_counter} guesses have been made and the most recent guess (#{guess}) was #{guessed_status(guess)}"
    else
      get_guess_request
    end

  end

  def guessed_status(guess= @guessed_number)
    return "too high" if guess > @number_to_guess
    return "too low" if guess < @number_to_guess
    "Correct"
  end

  def get_guess_request
    if @guessed_number
        "#{@guess_counter} guesses have been made and the most recent guess (#{@guessed_number}) was #{guessed_status}"
    else
      "No guesses made yet"
    end
  end

end

