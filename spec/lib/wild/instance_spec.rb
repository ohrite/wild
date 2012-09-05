require 'spec_helper'

describe Wild::Instance do
  include_context "zookeeper"

  let(:instance_data) { JSON.dump({dental_work: true}) }
  let(:instance) { Wild::Instance.new(zookeeper, instance_data) }

  describe "#start" do
    it "serves dental work" do
      instance.start
      `curl -s http://localhost:#{instance.port}`.should_not be_empty
    end
  end
end
