module YSI
  class Tag < Assertion
    needs "version"

    def display_name
      "tag"
    end

    def tag
      @engine.tag
    end

    def check
      Executor.new.run_command(["git", "tag"]).each_line do |line|
        if line.chomp == tag
          Executor.new.run_command(["git", "show", tag]).each_line do |show_line|
            if show_line =~ /Date:\s+(.*)/
              @engine.tag_date = $1
            end
          end
          return tag
        end
      end
      return nil
    end

    def assert(executor)
      executor.run_command(["git", "tag", "-a", tag, "-m", engine.version])
      tag
    end
  end
end
