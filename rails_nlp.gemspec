# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_nlp/version'

Gem::Specification.new do |spec|
  spec.name          = "rails_nlp"
  spec.version       = RailsNlp::VERSION
  spec.authors       = ["Philip Hale"]
  spec.email         = ["p.hale.09@aberdeen.ac.uk"]
  spec.summary       = "Supercharge your ActiveRecord text fields with NLP analysis."
  spec.description   = "Add Rails NLP to your Rails project to allow deeper full-text search across your ActiveRecord models."
  spec.homepage      = ""
  spec.license       = "TBC"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-rails", '~> 2.14.1'
  spec.add_development_dependency "factory_girl_rails", "~> 4.0"
  spec.add_development_dependency "guard", "~> 2.6"
  spec.add_development_dependency "guard-rspec", "~> 4.2.8"
  spec.add_development_dependency "flexmock", "~> 1.3.1"

  spec.add_runtime_dependency "facets", "~> 2.9"
  spec.add_runtime_dependency "sanitize", "~> 2.1"
  spec.add_runtime_dependency "activerecord", "~> 4.0"
end
