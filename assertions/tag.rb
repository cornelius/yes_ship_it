module YSI
  class Tag < Assertion
    def display_name
      "tag"
    end

    def tag
      @engine.tag
    end

    def check
      `git tag`.each_line do |line|
        if line.chomp == tag
          `git show #{tag}`.each_line do |show_line|
            if show_line =~ /Date:\s+(.*)/
              @engine.tag_date = $1
            end
          end
          return tag
        end
      end
      return nil
    end

    def assert(dry_run: false)
      if !dry_run
        `git tag -a #{tag} -m "Version #{@engine.version}"`
      end
      tag
    end
  end
end
