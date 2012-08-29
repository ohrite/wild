require 'spec_helper'

describe  Wild::Agent do
  include_context "zookeeper"

  let(:agent) { Wild::Agent.new(zookeeper) }
  let(:streetcar) { Wild::Streetcar.new(zookeeper) }

  after do
    zookeeper.rm_rf(Wild::Streetcar::DESIRE_PATH) if zookeeper.exists?('/desire')
  end

  describe "#reveal_desires" do
    before { streetcar.desire('dirt_and_ice_cream', {tasty: true}) }

    it "reveals a desire" do
      agent.reveal_desires.should == ['dirt_and_ice_cream']
    end

    describe "with multiple desires" do
      before { streetcar.desire('tickling_with_goose_feathers', {extra_tickly: true}) }

      it "reveals each desire" do
        agent.reveal_desires.should == ['tickling_with_goose_feathers', 'dirt_and_ice_cream']
      end
    end
  end
end
