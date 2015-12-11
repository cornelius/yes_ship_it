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
      response = Executor.new.run_command(["git", "ls-remote", "--tags", "origin", tag])
      if response.include?(tag)
        return response
      end

      nil
    end

    def assert(executor)
      executor.run_command(["git", "push", "--tags"])
      tag
    end
  end
end
