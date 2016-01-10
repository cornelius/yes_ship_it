module YSI
  class Assertion
    attr_accessor :engine

    def self.class_name(name)
      name.split("_").map { |n| n.capitalize }.join
    end

    def self.class_for_name(name)
      begin
        Object.const_get("YSI::" + class_name(name))
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

    def self.parameter(name, default_value = nil)
      define_method("#{name}=") do |value|
        @parameters[name] = value
      end

      if default_value
        define_method("#{name}_default") do
          return default_value
        end
      end

      define_method("#{name}") do
        if @parameters.has_key?(name)
          return @parameters[name]
        else
          if respond_to?("#{name}_default")
            return send("#{name}_default")
          else
            return nil
          end
        end
      end
    end

    def initialize(engine)
      @engine = engine
      @parameters = {}
      @parameter_defaults = {}
    end

    def display_name
      self.class.display_name
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
