require "zk"
require "zk-group"
require 'wild/instance'

class Wild::Agent
  GROUP_NAME = "agents"

  attr_reader :zookeeper_hosts, :peers
  attr_accessor :connection

  def initialize(zookeeper_hosts, ip_address = '127.0.0.1')
    @zookeeper_hosts = zookeeper_hosts
    @peers = []
    @member = register_with_zookeeper(ip_address)
  end

  def zookeeper_path
    @member.path
  end

  def ip_address
    @member.data
  end

  private

  def connection
    @connection ||= ZK.new(zookeeper_hosts)
  end

  def group
    @group ||= ZK::Group.new(connection, GROUP_NAME).tap(&:create)
  end

  def register_with_zookeeper(ip_address)
    group.on_membership_change(:absolute => true ) do |_, members|
      @peers = members.map { |key| connection.get(key).first }
    end
    group.join(ip_address)
  end
end
