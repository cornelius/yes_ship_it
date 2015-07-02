module YSI
  class Engine
    attr_reader :assertions
    attr_accessor :version, :tag_date
    attr_accessor :out

    def self.class_for_assertion_name(name)
      class_name = name.split("_").map { |n| n.capitalize }.join
      begin
        Object.const_get("YSI::" + class_name)
      rescue NameError
        raise YSI::Error.new("Error: Unknown assertion '#{name}'")
      end
    end

    def initialize
      @assertions = []
      @out = STDOUT
    end

    def read(filename)
      config = YAML.load_file(filename)

      assertions = config["assertions"]
      if assertions
        assertions.each do |assertion|
          if assertion == "version_number"
            out.puts "Warning: use `version` instead of `version_number`."
            out.puts
            assertion = "version"
          end

          @assertions << YSI::Engine.class_for_assertion_name(assertion).new(self)
        end
      end
    end

    def project_name
      File.basename(Dir.pwd)
    end

    def run
      failed_assertions = []

      @assertions.each do |assertion|
        out.print "Checking #{assertion.display_name}: "
        success = assertion.check
        if success
          out.puts success
        else
          out.puts "fail"
          if assertion.error
            out.puts "  " + assertion.error
          end
          failed_assertions.push(assertion)
        end
      end

      out.puts

      if failed_assertions.empty?
        if tag_date
          out.puts "#{project_name} #{version} already shipped on #{tag_date}"
        else
          out.puts "#{project_name} #{version} already shipped"
        end
        return 0
      else
        out.puts "Couldn't ship #{project_name}. Help me."
        return 1
      end
    end
  end
end
