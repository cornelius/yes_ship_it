module YSI
  class PushedTag < Assertion
    def display_name
      "pushed tag"
    end

    def tag
      "v#{@engine.version}"
    end

    def check
      response = `git ls-remote --tags origin #{tag}`
      if response.include?(tag)
        return response
      end

      nil
    end

    def assert(dry_run: false)
      if !dry_run
        `git push --tags`
      end
      tag
    end
  end
end
