module YSI
  class Plugin
    attr_accessor :out, :err

    def initialize(path)
      @plugin_dir = File.join(path, "yes_ship_it", "assertions")

      @out = STDOUT
      @err = STDERR
    end

    def load
      plugin_paths = []
      if File.exist?(@plugin_dir)
        plugin_paths = Dir.glob("#{@plugin_dir}/*.rb").sort
      end

      plugins = {}
      plugin_paths.each do |plugin_path|
        plugin_name = File.basename(plugin_path, ".rb")
        require plugin_path
        plugins[plugin_name] = YSI::Assertion.class_for_name(plugin_name)
      end

      plugins
    end

    def list
      plugins = load

      if plugins.empty?
        out.puts "There are no local plugins."
        out.puts
        out.puts "Create one with `yes_ship_it plugin init MyAssertion`."
        out.puts
        out.puts "Documentation about how to write plugins can be found at"
        out.puts
        out.puts "    https://github.com/cornelius/yes_ship_it/wiki/plugins"
      else
        plugins.each do |plugin_name, plugin_class|
          out.puts "#{plugin_name}: #{plugin_class.display_name}"
        end
      end
    end

    def generate(name, display_name)
      plugin_path = File.join(@plugin_dir, name + ".rb")

      if File.exist?(plugin_path)
        err.puts "Can't generate plugin. Plugin already exists at `#{plugin_path}`."
        exit 1
      end

      FileUtils.mkdir_p(@plugin_dir)

      File.open(plugin_path, "w") do |f|
        f.puts "module YSI"
        f.puts "  class #{YSI::Assertion.class_name(name)} < Assertion"
        f.puts "    def self.display_name"
        f.puts "      \"#{display_name}\""
        f.puts "    end"
        f.puts
        f.puts "    def check"
        f.puts "    end"
        f.puts
        f.puts "    def assert(executor)"
        f.puts "    end"
        f.puts "  end"
        f.puts "end"
      end

      out.puts "Generated assertion plugin at `#{plugin_path}`."
    end
  end
end
