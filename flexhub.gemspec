# frozen_string_literal: true

$:.push File.expand_path("../lib", __FILE__)
require "flexhub/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "flexhub"
  s.version     = Flexhub::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Eric Tuvesson"]
  s.email       = ["eric.tuvesson@gmail.com"]
  s.homepage    = "https://github.com/erictuvesson/flexhub"
  s.summary     = "Summary of Flexhub."
  s.description = "Description of Flexhub."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 6.0"
  s.add_dependency "haml"

  s.add_development_dependency "sqlite3"
end
