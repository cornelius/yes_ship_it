module YSI
  class Engine
    attr_reader :assertions

    def self.class_for_assertion_name(name)
      class_name = name.split("_").map { |n| n.capitalize }.join
      Object.const_get("YSI::" + class_name)
    end

    def initialize
      @assertions = []
    end

    def read(filename)
      config = YAML.load_file(filename)

      assertions = config["assertions"]
      if assertions
        assertions.each do |assertion|
          @assertions << YSI::Engine.class_for_assertion_name(assertion).new
        end
      end
    end
  end
end
