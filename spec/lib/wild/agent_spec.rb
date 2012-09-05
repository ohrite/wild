require 'spec_helper'

describe Wild::Agent do
  include_context "zookeeper"

  let(:agent) { Wild::Agent.new(zookeeper) }

  before { agent.stub(:heartbeat).and_return(false) }

  after(:each)do
    zookeeper.rm_rf(agent.desires.path) if zookeeper.exists?(agent.desires.path)
    zookeeper.rm_rf(agent.reality.path) if zookeeper.exists?(agent.reality.path)
  end

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
