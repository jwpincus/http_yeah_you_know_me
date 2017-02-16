class Game
  attr_writer :number_to_guess #this is here for testing
  def initialize
    @guess_counter = 0
    @number_to_guess = (0..100).to_a.shuffle.first
    @guessed_number = nil
  end

  def game(verb, body = nil)
    guess = body.split("=").last.to_i if !body.empty?
    if guess
      @guess_counter += 1
      @guessed_number = guess
      response
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
        response
    else
      "<html><head></head><body><h1>No guesses made yet</h1></body></html>"
    end
  end

  def response
    "<html><head></head><body><h1>#{@guess_counter} guesses have been made and the most recent guess (#{@guessed_number}) was #{guessed_status}</h1></body></html>"
  end
end