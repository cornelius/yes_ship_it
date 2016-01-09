class Init
  attr_accessor :out

  def initialize(path)
    @path = path

    @out = STDOUT
  end

  def setup_config
    config_file = File.join(@path, "yes_ship_it.conf")

    if File.exist?(config_file)
      out.puts "There already is a file `yes_ship_it.conf`."
      out.puts
      out.puts "This project does not seem to need initialization."
      return
    end

    out.puts "Initialized directory for shipping."
    out.puts
    File.open(config_file, "w") do |f|
      f.puts "# Experimental release automation. See https://github.com/cornelius/yes_ship_it."
      if File.exist?(File.join(@path, "lib", "version.rb"))
        out.puts "It looks like this is is Ruby project."

        f.puts "include:"
        f.puts "  ruby_gem"
      else
        out.puts "Couldn't determine type of project, wrote a generic template."

        f.puts "assertions:"
        f.puts "  - release_branch"
        f.puts "  - working_directory"
        f.puts "  - version"
        f.puts "  - change_log"
        f.puts "  - tag"
        f.puts "  - pushed_tag"
        f.puts "  - pushed_code"
        f.puts "  - yes_it_shipped"
      end
    end
    out.puts
    out.puts "Check the file `yes_ship_it.conf` and adapt it to your needs."
    out.puts
    out.puts "Happy shipping!"
  end
end
