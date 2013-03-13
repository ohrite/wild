require 'spec_helper'

describe Wild::Streetcar do
  let(:zookeeper_port) do
    begin
      server = TCPServer.new('127.0.0.1', 0)
      server.addr[1]
    ensure
      server.close if server
    end
  end

  let(:zookeeper_path) { Dir.mktmpdir("wild-zookeeper") }

  let!(:zookeeper_server) do
    ZK::Server.new(:client_port => zookeeper_port, :base_dir => zookeeper_path).tap{ |s| s.run }
  end

  let(:zookeeper_settings) { {:thread => :single} }
  let(:zookeeper_host) { "localhost:#{zookeeper_port}" }

  let(:zookeeper) { ZK.new(zookeeper_host) }

  after do
    zookeeper_server.shutdown
    zookeeper_server.clobber!
    FileUtils.rm_rf(zookeeper_path)
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
