class Wild::Instance
  attr_reader :port, :reality, :name_of_desire

  def initialize(reality, name_of_desire, data)
    @reality = reality
    @name_of_desire = name_of_desire
    @port = get_me_a_port
  end

  def start
    reality.add(name_of_desire)
    @instance = Process.spawn("python -m SimpleHTTPServer #{port}", err: '/dev/null', out: '/dev/null')
  end

  def stop
    Process.kill(@instance, 'HUP') if @instance
  end

  def get_me_a_port
    server = TCPServer.new('127.0.0.1', 0)
    server.addr[1]
  ensure
    server.close if server
  end
end
