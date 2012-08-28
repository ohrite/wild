require 'spec_helper'

describe  Wild::Agent do
  include_context "zookeeper"

  let(:agent) { Wild::Agent.new(zookeeper_host, '127.0.0.1') }
  let(:path) { agent.zookeeper_path }

  describe "the zookeeper group the agent creates" do
    it "should record its ip address to the group" do
      zookeeper.get(path).first.should == "127.0.0.1"
    end

    it "should remove the agent's ip address when the agent disconnects" do
      zookeeper.exists?(path).should be
      agent.send(:connection).close!
      zookeeper.exists?(path).should_not be
    end

    it "should keep track of all agents" do
      sleep 0.1 while agent.peers.empty?
      agent.peers.should include '127.0.0.1'
    end
  end
end
