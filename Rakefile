require "bundler/gem_tasks"

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task default: :spec

desc "build the gem and publish it to RubyGems"
task :publish do
  tag = "kolo-#{Kolo::VERSION}.gem"

  system "gem build kolo.gemspec --silent --output #{tag}"
  system "gem push #{tag}"
end
