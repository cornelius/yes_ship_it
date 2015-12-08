require "yaml"
require "rest-client"
require "optparse"
require "inifile"
require "rexml/document"
require "erb"

require_relative "yes_ship_it/assertion.rb"
require_relative "yes_ship_it/engine.rb"
require_relative "yes_ship_it/exceptions.rb"
require_relative "yes_ship_it/git.rb"

assertions_dir = File.expand_path("../../assertions", __FILE__)
Dir[File.join(assertions_dir, "*.rb")].each { |f| require(f) }
