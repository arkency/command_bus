# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arkency/command_bus/version'

Gem::Specification.new do |spec|
  spec.name          = "arkency-command_bus"
  spec.version       = Arkency::CommandBus::VERSION
  spec.authors       = ["Arkency"]
  spec.email         = ["dev@arkency.com"]

  spec.summary       = %q{Command Pattern - decoupling what is done from who does it.}
  spec.homepage      = "https://github.com/arkency/command_bus"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thread_safe"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4.0"
end
