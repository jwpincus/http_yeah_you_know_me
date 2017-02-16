require 'socket' 
class HelloServer

  def self.start_server
    counter = 1
    Socket.tcp_server_loop(9292) do |server|
      server.gets
      response = "<html><head></head><body><h1>Hello World!(#{counter})</></body></html>"
      headers = ["http/1.1 200 ok",
          "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
          "server: ruby",
          "content-type: text/html; charset=iso-8859-1",
          "content-length: #{response.length}\r\n\r\n"].join("\r\n")
      server.print headers
      server.print response
      server.print "\r\n"
      server.close
      counter += 1
      end
  end
end

HelloServer.start_server