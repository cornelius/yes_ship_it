module YSI
  class Engine
    attr_reader :assertions
    attr_accessor :version, :tag_date

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
    end

    def read(filename)
      config = YAML.load_file(filename)

      assertions = config["assertions"]
      if assertions
        assertions.each do |assertion|
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
        print "Checking #{assertion.display_name}: "
        success = assertion.check
        if success
          puts success
        else
          puts "fail"
          if assertion.error
            puts "  " + assertion.error
          end
          failed_assertions.push(assertion)
        end
      end

      puts

      if failed_assertions.empty?
        if tag_date
          puts "#{project_name} #{version} already shipped on #{tag_date}"
        else
          puts "#{project_name} #{version} already shipped"
        end
        return 0
      else
        puts "Couldn't ship #{project_name}. Help me."
        return 1
      end
    end
  end
end
