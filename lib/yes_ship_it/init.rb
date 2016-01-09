class Init
  def initialize(path)
    @path = path
  end

  def setup_config
    File.open(File.join(@path, "yes_ship_it.conf"), "w") do |f|
      f.puts "# Experimental release automation. See https://github.com/cornelius/yes_ship_it."
      f.puts "include:"
      f.puts "  ruby_gem"
    end
    true
  end
end
