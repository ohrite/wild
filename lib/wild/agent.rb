require 'logger'
require "zk"
require "zk-group"
require 'wild/streetcar'
require 'wild/instance'

class Wild::Agent
  attr_reader :desire, :reality, :logger

  def initialize(zookeeper)
    @logger ||= ::Logger.new(STDOUT).tap do |logger|
      logger.level = ::Logger::DEBUG
    end
    @zookeeper = zookeeper
    @desire = Wild::Streetcar.new(zookeeper, '/desire')
    @reality = Wild::Streetcar.new(zookeeper, '/reality')
  end

  def start
    logger.debug("Watching #{desire.path}")
    @zookeeper.register(desire.path) { ponder_reality }

    logger.debug("Watching #{reality.path}")
    @zookeeper.register(reality.path) { ponder_reality }
    
    ponder_reality

    sleep 10 while heartbeat
  end

  def heartbeat
    logger.info "reality=#{reality.count} desire=#{desire.count}"
    true
  end

  def ponder_reality
    world = reveal_desires
    logger.debug("Current desires are #{world}")
    reality.add(world.first, {})
    logger.info("Added #{world.first} to reality, desires are now #{reveal_desires}")
  end

  def reveal_desires
    desire.to_a - reality.to_a
  end
end
