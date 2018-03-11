# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'the_protector/version'

Gem::Specification.new do |spec|
  spec.name          = "the_protector"
  spec.version       = TheProtector::VERSION
  spec.authors       = ["Michele Finotto"]
  spec.email         = ["m@finotto.io"]

  spec.summary       = %q{Enable read-only mode on web services}
  spec.homepage      = "https://github.com/michele/the_protector"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rack-test", "~> 0.6.3"
  spec.add_development_dependency "rails", "~> 4.1"
  spec.add_development_dependency "webmock"
end
