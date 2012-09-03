require 'spec_helper'

describe  Wild::Agent do
  include_context "zookeeper"

  let(:agent) { Wild::Agent.new(zookeeper) }

  after do
    zookeeper.rm_rf(agent.desire.path) if zookeeper.exists?('/desire')
    zookeeper.rm_rf(agent.reality.path) if zookeeper.exists?('/reality')
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
