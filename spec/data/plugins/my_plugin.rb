module YSI
  class MyPlugin < Assertion
    def self.display_name
      "My awesome plugin"
    end

    def check
    end

    def assert(executor)
    end
  end
end
