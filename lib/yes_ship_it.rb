require "yaml"

require_relative "yes_ship_it/engine.rb"

assertions_dir = File.expand_path("../../assertions", __FILE__)
Dir[File.join(assertions_dir, "*.rb")].each { |f| require(f) }
