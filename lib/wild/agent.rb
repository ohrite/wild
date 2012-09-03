require "zk"
require "zk-group"
require 'wild/streetcar'
require 'wild/instance'

class Wild::Agent
  attr_reader :desire, :reality

  def initialize(zookeeper)
    @zookeeper = zookeeper
    @desire = Wild::Streetcar.new(zookeeper, '/desire')
    @reality = Wild::Streetcar.new(zookeeper, '/reality')
  end

  def reveal_desires
    desire.to_a - reality.to_a
  end
end
