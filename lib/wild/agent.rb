require 'logger'
require 'zk'
require 'wild/streetcar'

class Wild::Agent
  attr_reader :desires, :reality, :instances

  def self.logger
    @@logger ||= ::Logger.new(STDOUT).tap do |logger|
      logger.level = ::Logger::DEBUG
    end
  end

  def initialize(zookeeper)
    @zookeeper = zookeeper
    @desires = Wild::Streetcar.new(zookeeper, '/desires')
    @reality = Wild::Streetcar.new(zookeeper, '/reality')
    @instances = []
  end

  def logger
    self.class.logger
  end

  def start
    logger.debug("Watching #{desires.path}")

    @zookeeper.register(desires.path) do |event|
      logger.debug("Some horrible thing has happened #{event}")
      ponder(event)
    end

    logger.debug("Watching #{reality.path}")

    @zookeeper.register(reality.path) do |event|
      logger.debug("Some horrible thing has happened #{event}")
      ponder(event)
    end

    ponder

    sleep 1 while heartbeat
  end

  def heartbeat
    logger.info "reality=#{reality.count} desires=#{desires.count}"
    true
  end

  def ponder(event = nil)
    logger.debug("Current desires are #{reveal_desires}")

    if reveal_desires.any?
      latest = reveal_desires.first
      reality.add(latest)
      instances << Wild::Instance.new(zookeepeer, {})
    end

    logger.info("Added #{desires} to reality, desires are now #{reveal_desires}")
  end

  def reveal_desires
    desires.to_a - reality.to_a
  end
end
