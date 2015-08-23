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
      @dependency_names ||= []
      # Classes might not all be loaded yet, so delay class name lookup to
      # first invocation of #needs
      @dependency_names << dependency
    end

    def self.dependency_names
      @dependency_names || []
    end

    def self.parameter(name)
      define_method("#{name}=") do |value|
        @parameters[name] = value
      end

      define_method("#{name}") do
        return @parameters[name]
      end
    end

    def initialize(engine)
      @engine = engine
      @parameters = {}
    end

    def needs
      @dependencies ||= self.class.dependency_names.map do |d|
        Assertion.class_for_name(d)
      end
    end

    def needs?(dependency)
      needs.include?(dependency)
    end
  end
end
