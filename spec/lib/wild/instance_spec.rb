require 'spec_helper'

describe Wild::Instance do
  include_context "zookeeper"

  describe "when freshly created" do
    subject { Wild::Instance.new(zookeeper, 'testing') }

    its(:name) { should == 'testing' }
    its(:port) { should be }
  end
end
