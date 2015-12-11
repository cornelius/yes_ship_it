module YSI
  class ChangeLog < Assertion
    needs "version"

    def display_name
      "change log"
    end

    def check
      if !File.exist?("CHANGELOG.md")
        raise AssertionError.new("Expected change log in CHANGELOG.md")
      end

      check_content(File.read("CHANGELOG.md"))

      "CHANGELOG.md"
    end

    def assert(_executor)
    end

    def check_content(content)
      if content !~ /#{engine.version}/
        raise AssertionError.new("Can't find version #{engine.version} in change log")
      end
    end
  end
end
