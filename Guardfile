notification :terminal_notifier, :app_name => "Wild ::"

guard 'rspec', version: 2, cli: '--format documentation --color --tty --fail-fast', bundler: true do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})       { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{spec/contexts/.+\.rb}) { "spec" }
  watch('spec/spec_helper.rb')    { "spec" }
end

guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end
