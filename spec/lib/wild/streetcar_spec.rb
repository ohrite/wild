require 'spec_helper'

describe Wild::Streetcar do
  include_context 'zookeeper'

  after do
    zookeeper.rm_rf(Wild::Streetcar::DESIRE_PATH) if zookeeper.exists?('/desire')
  end

  let(:streetcar) { Wild::Streetcar.new(zookeeper) }

  describe '.desire' do
    it "can create a desired instance" do
      streetcar.desire("vivien_leigh", {gams: 'nice'})
      zookeeper.exists?('/desire/vivien_leigh').should be_true
      zookeeper.get('/desire/vivien_leigh').first.should == "{\"gams\":\"nice\"}"
    end
  end

  describe '.spurn' do
    before { streetcar.desire("marlon_brando", {dancing: 'no'}) }

    it "can delete an instance" do
      streetcar.spurn('marlon_brando') # :(
      zookeeper.exists?('/desire/marlon_brando').should be_false
    end
  end
end
