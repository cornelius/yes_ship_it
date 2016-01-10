module YSI
  class PushedCode < Assertion
    needs "release_branch"

    def self.display_name
      "pushed code"
    end

    def check
      if Git.new(Executor.new).needs_push?
        return nil
      else
        return "up-to-date"
      end
    end

    def assert(executor)
      Git.new(executor).push
      return "pushed"
    end
  end
end
