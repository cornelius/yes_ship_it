module YSI
  class PushedCode < Assertion
    needs "release_branch"

    def self.display_name
      "pushed code"
    end

    def check
      branch = self.engine.assertions.find { |assertion| assertion.is_a?(YSI::ReleaseBranch) }&.branch || "master"

      if Git.new(Executor.new, Dir.pwd, branch).needs_push?
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
