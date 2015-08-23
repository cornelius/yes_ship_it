module YSI
  class WorkingDirectory < Assertion
    def display_name
      "working directory"
    end

    def git_status
      `git status`
    end

    def status
      if !@status
        g = git_status
        if g =~ /working directory clean/
          @status = "clean"
        elsif g =~ /Changes to be committed/
          @status = "uncommitted changes"
        elsif g =~ /Untracked files/
          @status = "untracked files"
        elsif g =~ /Changes not staged/
          @status = "unstaged changes"
        else
          @status = nil
        end
      end
      @status
    end

    def check
      if status == "clean"
        return status
      else
        @error = status
        return nil
      end
    end

    def assert(dry_run: false)
      "clean"
    end
  end
end
