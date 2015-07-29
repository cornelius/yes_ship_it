module YSI
  class ReleaseBranch < Assertion
    attr_accessor :error

    def initialize(engine)
      @engine = engine
    end

    def display_name
      "release branch"
    end

    def branch
      "master"
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
        @error = "Not on release branch '#{branch}'"
        return nil
      else
        return branch
      end
    end

    def assert(dry_run: false)
      branch
    end
  end
end
