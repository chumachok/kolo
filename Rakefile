

desc "build the gem and publish it to RubyGems"
task :publish do
  tag = "kolo-#{Kolo::VERSION}.gem"

  system "gem build kolo.gemspec --silent --output #{tag}"
  system "gem push #{tag}"
end