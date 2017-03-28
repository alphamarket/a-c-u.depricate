$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acu/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acu"
  s.version     = Acu::VERSION
  s.authors     = ["Dariush Hasanpour"]
  s.email       = ["b.g.dariush@gmail.com"]
  s.homepage    = "https://github.com/noise2/acu-rails"
  s.summary     = "Access Control Unit"
  s.description = "A Rolebased Access Control Unit Gem"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.2"
end
