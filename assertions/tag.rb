module YSI
  class Tag < Assertion
    def display_name
      "tag"
    end

    def tag
      "v#{@engine.version}"
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
      @error = "Tag #{tag} is not there yet"
      return nil
    end

    def assert
    end
  end
end
