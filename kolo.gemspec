lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "kolo/version"

Gem::Specification.new do |spec|
  spec.name          = "kolo"
  spec.version       = Kolo::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Maksym Chumak"]
  spec.email         = ["chumachok11@gmail.com"]
  spec.summary       = "Roda app generator"
  spec.description   = "Command line utility for generating roda applications"
  spec.homepage      = "https://github.com/chumachok/kolo"

  spec.license       = "MIT"

  spec.files         = "git ls-files".split($/).reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.executables   = ["kolo"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 13.0"
end