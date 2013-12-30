# encoding: utf-8

Gem::Specification.new do |spec|
  spec.name    = "walkman"
  spec.version = "0.1.3"

  spec.author      = "Tres Trantham"
  spec.email       = "tres@trestrantham.com"
  spec.description = "Control your music"
  spec.summary     = "Control your music"
  spec.homepage    = "https://github.com/trestrantham/walkman"
  spec.license     = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(/^spec/)
  spec.require_paths = ["lib"]
  spec.executables   = "walkman"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.1"

  spec.add_dependency "activemodel", "~> 4.0.2"
  spec.add_dependency "command", "~> 1.0"
  spec.add_dependency "echowrap", "~> 0.1.0"
  spec.add_dependency "sinatra", "~> 1.4.4"
  spec.add_dependency "thor", "~> 0.18.1"
  spec.add_dependency "titleize", "~> 1.3.0"
end
