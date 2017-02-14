require_relative 'http'

loop do
  Server.new.start_server
end