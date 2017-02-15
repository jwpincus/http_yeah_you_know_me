class WordSearch
  
  def word_search(path)
    word = path.split('=')[-1]
    dictionary = File.open('./data/all_words.txt').read
    if dictionary.include? "\n#{word}\n"
      "<html><head></head><body><h1>#{word.capitalize} is a known word</h1></body></html>"
    else
      "<html><head></head><body><h1>#{word.capitalize} is an unknown word</h1></body></html>"
    end
  end

end
