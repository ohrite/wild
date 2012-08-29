require 'thor'
require 'wild/agent'

class Wild::CLI < Thor
  desc 'start', 'Start an agent.'
  def start(destination, data = local_ip)
    agent = Wild::Agent.new(destination, data)
    while true do
      puts agent.peers
      sleep 5
    end
  end

  private

  def local_ip
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true
    UDPSocket.open do |s|
      s.connect '8.8.8.8', 1
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = orig
  end
end
