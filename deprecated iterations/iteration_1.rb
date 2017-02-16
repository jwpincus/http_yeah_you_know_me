require 'socket' 
require 'pry'

class Server

  def self.start_server
    counter = 1
    request_lines = []
    Socket.tcp_server_loop(9292) do |server, address|
      
      while line = server.gets and !line.chomp.empty?
        request_lines << line.chomp
      end
      hashed_lines = parse_request_lines(request_lines)
      response = "<html><head></head><body><h1>Hello World!(#{counter})</h1></body></html>"
      pre = pre_format(hashed_lines)
      server.print "\r\n"
      server.print response
      server.print pre
      server.close
      counter += 1
      end
  end

  def self.parse_request_lines(request_lines)
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

  def self.parse_verb_path_protocol(line)
      first_line_hash = {}
      line = line.split(" ", 3)
      first_line_hash["Verb"] = line[0]
      first_line_hash["Path"] = line[1]
      first_line_hash["Protocol"] = line[2]
      first_line_hash
  end

  def self.pre_format(hashed_lines)
    "<pre>
    Verb: #{hashed_lines['Verb']}
    Path: #{hashed_lines['Path']}
    Protocol: #{hashed_lines['Protocol']}
    Host: #{hashed_lines['Host']}
    Origin: 127.0.0.1
    Accept: #{hashed_lines["Accept"]}
    </pre>"
  end

end

# Server.start_server
