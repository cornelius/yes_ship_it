require_relative "../../lib/yes_ship_it.rb"

support = File.expand_path("../support", __FILE__) + "/*.rb"

Dir[support].each { |f| require f }
