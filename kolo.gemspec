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

  spec.files         = "git ls-files".split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  # TODO: figure out dependencies
end