module Wild
  class Instance
    attr_reader :name

    def initialize(connection, instance_name)
      @connection = connection
      @name = instance_name
      @member = register_with_zookeeper(instance_port)
    end

    def port
      @member.data
    end

    private

    def connection
      @connection
    end

    def group
      @group ||= ZK::Group.new(connection, name).tap(&:create)
    end

    def register_with_zookeeper(port)
      group.join(port)
    end

    def instance_port
      server = TCPServer.new('127.0.0.1', 0)
      server.addr[1]
    ensure
      server.close if server
    end
  end
end
