module YSI
  class Assertion
    attr_reader :error
    attr_accessor :engine

    def initialize(engine)
      @engine = engine
    end
  end
end
