require_relative "../../lib/yes_ship_it.rb"

require "given_filesystem/spec_helpers"

support = File.expand_path("../support", __FILE__) + "/*.rb"

Dir[support].each { |f| require f }
