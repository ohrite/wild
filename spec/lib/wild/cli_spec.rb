require 'spec_helper'

describe Wild::CLI do
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

  let(:cli) { Wild::CLI.new }

  before { cli.stub(:zookeeper).and_return(zookeeper) }
  after do
    zookeeper.rm_rf(cli.agent.desires.path) if zookeeper.exists?(cli.agent.desires.path)
    zookeeper.rm_rf(cli.agent.reality.path) if zookeeper.exists?(cli.agent.reality.path)
  end

  describe "#add" do
    it "adds a desire" do
      cli.add("stella")
      zookeeper.exists?('/desires/stella').should be_true
    end

    it "allows a desire to be added with data" do
      the_datas = {data: 'yes'}
      cli.add("stella", the_datas)
      zookeeper.get('/desires/stella').first.should == ::JSON.dump(the_datas)
    end
  end

  describe "the zookeeper connection that cli manages" do
    it "registers on (and later closes) the connection" do
      cli.agent.stub(:heartbeat).and_return(false)
      zookeeper.should_receive(:register).twice
      zookeeper.should_receive(:close!)
      cli.start
    end
  end
end
