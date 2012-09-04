require 'spec_helper'

describe  Wild::Agent do
  include_context "zookeeper"

  let(:agent) { Wild::Agent.new(zookeeper) }

  before { agent.stub(:heartbeat).and_return(false) }

  after do
    zookeeper.rm_rf(agent.desire.path) if zookeeper.exists?('/desire')
    zookeeper.rm_rf(agent.reality.path) if zookeeper.exists?('/reality')
  end

  describe "#start" do
    it "listens to streetcars" do
      zookeeper.should_receive(:register).with(agent.desire.path)
      zookeeper.should_receive(:register).with(agent.reality.path)
      agent.start
    end
  end

  describe "#ponder_reality" do
    before { agent.desire.add('bottle_of_gin', tasty: true)}

    it "adds missing desires to reality" do
      agent.reality.should have(0).things
      agent.ponder_reality
      agent.reality.first.should == 'bottle_of_gin'
    end
  end

  describe "#reveal_desires" do
    before { agent.desire.add('dirt_and_ice_cream', {tasty: true}) }

    it "reveals a desire" do
      agent.reveal_desires.should == ['dirt_and_ice_cream']
    end

    describe "with multiple desires" do
      before { agent.desire.add('tickling_with_goose_feathers', {extra_tickly: true}) }

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
