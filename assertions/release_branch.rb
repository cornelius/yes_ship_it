module YSI
  class ReleaseBranch < Assertion
    parameter :branch_name, "master"
    def self.display_name
      "release branch"
    end

    def branch
      branch_name
    end

    def current_branch
      git_branch.each_line do |line|
        if line =~ /\* (.*)/
          return $1
        end
      end
      nil
    end

    def git_branch
      `git branch`
    end

    def check
      if current_branch != branch
        raise AssertionError.new("Not on release branch '#{branch}'")
      else
        return branch
      end
    end

    def assert(_executor)
      branch
    end
  end
end
