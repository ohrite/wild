require File.expand_path( '../lib/wild/version', __FILE__ )

Gem::Specification.new do |s|
  s.name     = 'wild'
  s.version  = Wild::VERSION
  s.platform = Gem::Platform::RUBY
  s.homepage = 'https://github.com/ohrite/wild'
  s.authors  = [ 'Doc Ritezel' ]
  s.email    = 'ritezel+ohrite@gmail.com'
  s.summary  = "Zookeeper's a jungle."
  s.description        = 'Ephemeral instance allocation on top of Zookeeper.'
  s.executables        = %w(wild)
  s.default_executable = 'wild'

  s.add_dependency 'thor'
  s.add_dependency 'zk'
  s.add_dependency 'zk-group'
  s.add_dependency 'zk-server'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'guard-bundler'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'terminal-notifier-guard'
  
  s.files         = `git ls-files`.split( "\n" )
  s.test_files    = `git ls-files -- spec/*`.split( "\n" )
  s.require_path  = 'lib'
end
