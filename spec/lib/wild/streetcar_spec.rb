require 'spec_helper'

describe Wild::Streetcar do
  include_context 'zookeeper'

  after do
    zookeeper.rm_rf(streetcar.path) if zookeeper.exists?('/desire')
  end

  let(:streetcar) { Wild::Streetcar.new(zookeeper, '/desire') }

  describe '.add' do
    before { streetcar.add("stella", {gams: 'nice'}) }
    
    it "can create a desired instance" do
      zookeeper.exists?('/desire/stella').should be_true
      zookeeper.get('/desire/stella').first.should == "{\"gams\":\"nice\"}"
    end

    it "does not bail if the instance already exists" do
      expect { streetcar.add("stella", {gams: 'nice'}) }.to_not raise_error
    end
  end

  describe "when an instance has been desired" do
    before { streetcar.add("stanley", {background: 'army'}) }

    describe '.remove' do
      before { streetcar.remove('stanley') }

      it "can delete an instance" do
        zookeeper.exists?('/desire/stanley').should be_false
      end

      it "does not bail if the instance does not exist" do
        expect { streetcar.remove("stella") }.to_not raise_error
      end
    end

    describe '.each' do
      it "should build enumerable functions" do
        streetcar.should include 'stanley'
      end
    end
  end
end
