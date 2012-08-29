require 'thor'
require 'wild/agent'

class Wild::CLI < Thor
  desc 'start', 'Start an agent.'
  def start(destination)
    agent = Wild::Agent.new(destination)
    while true do
      puts agent.peers
      sleep 5
    end
  end
end
