require 'json'

class Wild::Streetcar
  include Enumerable

  attr_reader :path

  def initialize(zookeeper, streetcar_path)
    @zookeeper = zookeeper
    @path = streetcar_path
  end

  def add(name, data)
    @zookeeper.mkdir_p(path)
    desire_path = File.join(path, name)
    @zookeeper.create(desire_path, ::JSON.dump(data))
  end

  def remove(name)
    desire_path = File.join(path, name)
    @zookeeper.delete(desire_path)
  end

  def each(&block)
    @zookeeper.mkdir_p(path)
    @zookeeper.children(path).each do |child_path|
      yield child_path
    end
  end
end
