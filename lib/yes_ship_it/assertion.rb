module YSI
  class Assertion
    attr_reader :error
    attr_accessor :engine

    def self.class_for_name(name)
      class_name = name.split("_").map { |n| n.capitalize }.join
      begin
        Object.const_get("YSI::" + class_name)
      rescue NameError
        raise YSI::Error.new("Error: Unknown assertion '#{name}'")
      end
    end

    def self.needs(dependency)
      @@dependencies ||= []
      @@dependencies << dependency
    end

    def initialize(engine)
      @engine = engine
    end

    def needs
      @@dependencies
    end

    def needs?(dependency)
      @@dependencies.include?(dependency)
    end
  end
end
