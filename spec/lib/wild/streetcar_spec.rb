require 'spec_helper'

describe Wild::Streetcar do
  include_context 'zookeeper'

  after do
    zookeeper.rm_rf(streetcar.path) if zookeeper.exists?('/desire')
  end

  let(:streetcar) { Wild::Streetcar.new(zookeeper, '/desire') }

  describe '.add' do
    it "can create a desired instance" do
      streetcar.add("stella", {gams: 'nice'})
      zookeeper.exists?('/desire/stella').should be_true
      zookeeper.get('/desire/stella').first.should == "{\"gams\":\"nice\"}"
    end
  end

  describe "when an instance has been desired" do
    before { streetcar.add("stanley", {background: 'army'}) }

    describe '.remove' do
      it "can delete an instance" do
        streetcar.remove('stanley')
        zookeeper.exists?('/desire/stanley').should be_false
      end
    end

    describe '.each' do
      it "should build enumerable functions" do
        streetcar.should include 'stanley'
      end
    end
  end
end
