require 'spec_helper'

describe Wild::Agent do
  let(:zookeeper_port) do
    begin
      server = TCPServer.new('127.0.0.1', 0)
      server.addr[1]
    ensure
      server.close if server
    end
  end

  let(:zookeeper_path) { Dir.mktmpdir("wild-zookeeper") }

  let!(:zookeeper_server) do
    ZK::Server.new(:client_port => zookeeper_port, :base_dir => zookeeper_path).tap{ |s| s.run }
  end

  let(:zookeeper_settings) { {:thread => :single} }
  let(:zookeeper_host) { "localhost:#{zookeeper_port}" }

  let(:zookeeper) { ZK.new(zookeeper_host) }

  after do
    zookeeper_server.shutdown
    zookeeper_server.clobber!
    FileUtils.rm_rf(zookeeper_path)
  end

  let(:agent) { Wild::Agent.new(zookeeper) }

  before { agent.stub(:heartbeat).and_return(false) }

  describe "#start" do
    it "listens to streetcars" do
      zookeeper.should_receive(:register).with(agent.desires.path)
      zookeeper.should_receive(:register).with(agent.reality.path)
      agent.start
    end
  end

  describe "#ponder" do
    it "only adds current desires" do
      expect { agent.ponder }.to_not change { agent.reality.count }
    end

    describe "when things are desired" do
      before { agent.desires.add('bottle_of_gin', tasty: true) }

      it "adds missing desires to reality" do
        expect { agent.ponder }.to change { agent.reality.count }.from(0).to(1)
        agent.reality.first.should == 'bottle_of_gin'
      end

      it "creates a new instance" do
        expect { agent.ponder }.to change { agent.instances.count }.from(0).to(1)
      end
    end
  end

  describe "#reveal_desires" do
    before { agent.desires.add('dirt_and_ice_cream', {tasty: true}) }

    it "reveals a desire" do
      agent.reveal_desires.should == ['dirt_and_ice_cream']
    end

    describe "with multiple desires" do
      before { agent.desires.add('tickling_with_goose_feathers', {extra_tickly: true}) }

      it "reveals each desire" do
        agent.reveal_desires.should =~ ['tickling_with_goose_feathers', 'dirt_and_ice_cream']
      end

      describe "when a desire is fulfilled" do
        before { agent.reality.add('dirt_and_ice_cream', {}) }

        it "reveals the unfulfilled desire" do
          agent.reveal_desires.should =~ ['tickling_with_goose_feathers']
        end
      end
    end
  end
end
