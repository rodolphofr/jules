# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jules/version'

Gem::Specification.new do |spec|
  spec.name          = "jules"
  spec.version       = Jules::VERSION
  spec.author        = "Rodolpho Rodrigues"
  spec.email         = "rodolpho.frodrigues@gmail.com"

  spec.summary       = "A Page Object Model DSL for Calabash Android"
  spec.description   = "A awesome Page Object Model DSL for Calabash Android"
  spec.homepage      = "https://github.com/rodolphofr/jules.git"
  spec.license       = "MIT"

  spec.files         = Dir.glob('lib/**/*')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_path  = "lib"

  spec.add_development_dependency "calabash-android", "~> 0.9.0"
  spec.add_development_dependency "rspec"
end
