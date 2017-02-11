require 'socket' # Provides TCPServer and TCPSocket classes
class HelloServer
  def self.start_server
    server = TCPServer.new(9292)
    counter = 1
    server_run(server, counter)
    
  end

  def self.server_run(server, counter)
    loop do
      socket = server.accept
      request = socket.gets
      response = "Hello World!\n (#{counter})"
      socket.print "\r\n"
      socket.print response
      socket.close
      counter += 1
    end
  end

end

HelloServer.start_server