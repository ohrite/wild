require "zk-server"
require 'tmpdir'

shared_context "zookeeper" do
  let(:zookeeper_port) do
    begin
      server = TCPServer.new('127.0.0.1', 0)
      server.addr[1]
    ensure
      server.close if server
    end
  end

  let(:zookeeper_path) { Dir.mktmpdir("wild-zookeeper") }

  let(:zookeeper_server) do
    ZK::Server.new(:client_port => zookeeper_port, :base_dir => zookeeper_path)
  end
  let(:zookeeper_settings) { {:thread => :single} }
  let(:zookeeper_host) { "localhost:#{zookeeper_port}" }

  before(:all) { zookeeper_server.run }

  let(:zookeeper) { ZK.new(zookeeper_host) }

  after(:all) do
    zookeeper_server.shutdown
    zookeeper_server.clobber!
    FileUtils.rm_rf(zookeeper_path)
  end
end
