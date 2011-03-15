# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "yesterday/version"

Gem::Specification.new do |s|
  s.name        = "yesterday"
  s.version     = Yesterday::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Diederick Lawson"]
  s.email       = ["webmaster@altovista.nl"]
  s.homepage    = ""
  s.summary     = "Track history in your active record models"
  s.description = "Track history and view any made changes in your active record models"

  s.rubyforge_project = "yesterday"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'sqlite3'
end
