module YSI
  class ChangeLog < Assertion
    needs :version

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

      @error = check_content(File.read("CHANGELOG.md"))
      if @error
        return nil
      end

      "CHANGELOG.md"
    end

    def assert(dry_run: false)
    end

    def check_content(content)
      if content =~ /#{engine.version}/
        nil
      else
        return "Can't find version #{engine.version} in change log"
      end
    end
  end
end
