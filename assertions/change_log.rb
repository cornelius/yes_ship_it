module YSI
  class ChangeLog
    attr_reader :error

    def initialize(engine)
      @engine = engine
    end

    def display_name
      "change log"
    end

    def check
      if !File.exist?("CHANGELOG.md")
        @error = "Expected change log in CHANGELOG.md"
        return nil
      end

      "CHANGELOG.md"
    end

    def assert
    end
  end
end
