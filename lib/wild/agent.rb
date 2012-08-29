require "zk"
require "zk-group"
require 'wild/instance'

class Wild::Agent
  def initialize(zookeeper)
    @zookeeper = zookeeper
  end

  def reveal_desires
    @zookeeper.children(Wild::Streetcar::DESIRE_PATH)
  end
end
