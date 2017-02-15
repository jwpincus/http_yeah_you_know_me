require 'socket' 
require 'pry-state'
require_relative 'path_output'

class Server
                
  def initialize
    @path = Path.new
  end
  
  def start_server
      Socket.tcp_server_loop(9292) do |server, address|
          request_lines = []
          while line = server.gets and !line.chomp.empty?
            request_lines << line.chomp
          end
          hashed_lines = parse_request_lines(request_lines)
          body = server.read(hashed_lines['Content-Length'].to_i)
          to_print = response(hashed_lines, body)
          pre = pre_format(hashed_lines)
          server.print headers(to_print, pre)
          server.print to_print
          server.print pre
          server.close
          break if hashed_lines['Path'] == "/shutdown"
        end
  end

  def response(hashed_lines, body)
    @path.path_dependent_output(hashed_lines['Path'], hashed_lines['Verb'], body)
  end

  def headers(to_print, pre)
    re_code = '200 ok'
    if to_print.include?("Response Code")
      re_code = to_print.split(": ")[1]
    end if to_print
    ["http/1.1 #{re_code}",
    "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
    "server: ruby",
    "content-type: text/html; charset=iso-8859-1",
    "content-length: #{(to_print.length+pre.length) if to_print}\n\r\n"].join("\r\n")
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

end

