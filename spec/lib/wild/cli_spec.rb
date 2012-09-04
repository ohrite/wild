require 'spec_helper'

describe Wild::CLI do
  include_context "zookeeper"

  let(:cli) { Wild::CLI.new }

  before { cli.stub(:zookeeper).and_return(zookeeper) }

  describe "#add" do
    it "adds a desire" do
      cli.add("stella")
      zookeeper.exists?('/desire/stella').should be_true
    end
  end

  describe "#new" do
    it "starts an agent" do
      cli.agent.should_receive(:start)
      cli.start
    end
  end
end
