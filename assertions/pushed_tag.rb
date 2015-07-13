module YSI
  class PushedTag < Assertion
    needs "tag"

    def display_name
      "pushed tag"
    end

    def tag
      @engine.tag
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
