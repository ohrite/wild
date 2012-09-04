require 'thor'
require 'wild'

class Wild::CLI < Thor
  desc 'add', 'Adds a desire.'
  def add(desire, data = {})
    Wild::Streetcar.new(zookeeper, '/desire').add(desire, data)
  end

  desc 'start', 'Starts the agent.'
  def start
    agent.start
  ensure
    zookeeper.close!
  end

  no_tasks do
    def agent
      @agent ||= Wild::Agent.new(zookeeper)
    end

    def zookeeper
      @zookeeper ||= ZK.new("localhost:2181")
    end
  end
end
