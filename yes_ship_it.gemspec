# -*- encoding: utf-8 -*-
require File.expand_path("../lib/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "yes_ship_it"
  s.version     = YSI::VERSION
  s.license     = 'MIT'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Cornelius Schumacher']
  s.email       = ['schumacher@kde.org']
  s.homepage    = "http://github.com/cornelius/yes_ship_it"
  s.summary     = "The ultimate release script"
  s.description = "Whenever the answer is 'Yes, ship it!' you will need yes_ship_it. It is the ultimate helper in releasing software.."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "yes_ship_it"

  s.add_development_dependency "rspec", "~>3"
  s.add_development_dependency "given_filesystem"
  s.add_development_dependency "cli_tester", ">= 0.0.2"

  s.files        = `git ls-files`.split("\n")
  s.require_path = 'lib'
end
