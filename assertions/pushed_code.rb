module YSI
  class PushedCode < Assertion
    needs "release_branch"

    def display_name
      "pushed code"
    end

    def check
      if Git.new.needs_push?
        return nil
      else
        return "up-to-date"
      end
    end

    def assert(dry_run: false)
      if !dry_run
        Git.new.push
      end
      return "pushed"
    end
  end
end
