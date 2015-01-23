# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pentomino/version'

Gem::Specification.new do |spec|
  spec.name          = "pentomino"
  spec.version       = Pentomino::VERSION
  spec.authors       = ["zariganitosh"]
  spec.email         = ["XXXX@example.com"]
  spec.summary       = %q{Find answer of pentomino puzzle.}
  spec.description   = %q{Find answer of pentomino puzzle on the board(3x20, 4x15, 5x12, 6x10, 7x9-3, 8x8-4).}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
