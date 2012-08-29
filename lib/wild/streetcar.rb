require 'json'

class Wild::Streetcar
  DESIRE_PATH = '/desire'

  def initialize(zookeeper)
    @zookeeper = zookeeper
  end

  def desire(name, data)
    desire_path = File.join(DESIRE_PATH, name)
    @zookeeper.mkdir_p(DESIRE_PATH)
    @zookeeper.create(desire_path, ::JSON.dump(data))
  end

  def spurn(name)
    desire_path = File.join(DESIRE_PATH, name)
    @zookeeper.delete(desire_path)
  end
end
