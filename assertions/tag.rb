module YSI
  class Tag < Assertion
    needs "version"

    def self.display_name
      "tag"
    end

    def tag
      @engine.tag
    end

    def get_tag_date(executor)
      output = executor.run_command(["git", "show", tag])
      if output
        output.each_line do |show_line|
          if show_line =~ /Date:\s+(.*)/
            @engine.tag_date = Time.strptime($1,"%a %b %d %H:%M:%S %Y %z")
          end
        end
      end
    end

    def check
      Executor.new.run_command(["git", "tag"]).each_line do |line|
        if line.chomp == tag
          get_tag_date(YSI::Executor.new)
          return tag
        end
      end
      return nil
    end

    def assert(executor)
      executor.run_command(["git", "tag", "-a", tag, "-m", engine.version])
      get_tag_date(executor)
      tag
    end
  end
end
