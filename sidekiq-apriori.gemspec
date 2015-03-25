# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "sidekiq-apriori/version"

Gem::Specification.new do |s|
  s.name        = "sidekiq-apriori"
  s.license     = 'MIT'
  s.version     = Sidekiq::Apriori::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Blake Thomas", "Enova"]
  s.email       = ["bwthomas@gmail.com"]
  s.homepage    = "https://github.com/bwthomas/sidekiq-apriori"
  s.summary     = %q{Prioritization Middleware for Sidekiq}
  s.description = %q{Prioritization middleware for Sidekiq}
  s.rubyforge_project = "nowarning"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "activerecord"
  s.add_development_dependency "fakeredis"
  s.add_development_dependency "pry"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~>3.0"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "simplecov-rcov"
  s.add_development_dependency "sqlite3"

  s.add_dependency "sidekiq"
end
