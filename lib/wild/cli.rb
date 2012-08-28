require 'thor'

class Wild::CLI < Thor
  desc 'agents', 'Retrieves a list of agents.'
  def agents
  end

  desc 'create', 'Create a new application given a tarball url.'
  def create(name, tarball_url)
  end

  desc 'applications', 'Retrieves a list of applications, optionally for an agent.'
  def applications(agent = nil)
  end

  desc 'environment', 'Retrieves the environment for an agent.'
  def environment(application)
  end

  desc 'set', 'Sets an environment variable for an agent.'
  def set(application, key, value)
  end
end
