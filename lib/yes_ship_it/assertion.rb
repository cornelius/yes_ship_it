module YSI
  class Assertion
    attr_reader :error
    attr_accessor :engine

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
