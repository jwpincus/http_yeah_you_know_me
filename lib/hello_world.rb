require 'socket' # Provides TCPServer and TCPSocket classes


server = TCPServer.new(9292)
counter = 1

loop do
  socket = server.accept
  request = socket.gets
  response = "Hello World!\n (#{counter})"
  socket.print "\r\n"
  socket.print response
  socket.close
  counter += 1
end