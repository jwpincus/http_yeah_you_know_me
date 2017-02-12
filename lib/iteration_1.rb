require 'socket' 
require 'pry'

class HelloServer

  def self.start_server
    counter = 1
    request_lines = []
    Socket.tcp_server_loop(9292) do |server|
      counter = hello_world(server, counter)
    end
  end

  def self.hello_world(server, counter)
      server.gets
      response = "<html><head></head><body><h1>Hello World!(#{counter})</></body></html>"
      server.print "\r\n"
      server.print response
      server.close
      counter += 1
      counter
  end

end

HelloServer.start_server
