require 'socket' 
require 'pry-state'
class Server
  attr_accessor :hit_counter
  def initialize
    @hit_counter = 0
    @server = true
  end
  def start_server
      Socket.tcp_server_loop(9292) do |server, address|
          request_lines = []
          while line = server.gets and !line.chomp.empty?
            request_lines << line.chomp
          end
          hashed_lines = parse_request_lines(request_lines)
          response = path_dependent_output(hashed_lines['Path'])
          pre = pre_format(hashed_lines)
          server.print "\r\n"
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

  def path_dependent_output(path)
    @hit_counter += 1
    case path
    when "/"
      return nil
    when "/hello"
      return "<html><head></head><body><h1>Hello World!(#{@hit_counter})</h1></body></html>"
    when "/datetime"
      Time.now.strftime('%H:%M:%S on %a, %e %b %Y ')
    when "/shutdown"
      "<html><head></head><body><h1>Total Requests: #{@hit_counter}</h1></body></html>"
    end
  end

end

