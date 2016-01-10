require "yaml"
require "rest-client"
require "optparse"
require "inifile"
require "rexml/document"
require "erb"
require "cheetah"
require "time"

require_relative "yes_ship_it/assertion.rb"
require_relative "yes_ship_it/engine.rb"
require_relative "yes_ship_it/exceptions.rb"
require_relative "yes_ship_it/git.rb"
require_relative "yes_ship_it/executor.rb"
require_relative "yes_ship_it/dry_executor.rb"
require_relative "yes_ship_it/init.rb"
require_relative "yes_ship_it/plugin.rb"

assertions_dir = File.expand_path("../../assertions", __FILE__)
Dir[File.join(assertions_dir, "*.rb")].each { |f| require(f) }
