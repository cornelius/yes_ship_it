module YSI
  class BuiltGem < Assertion
    def display_name
      "built gem"
    end

    def gem_file
      "#{@engine.project_name}-#{@engine.version}.gem"
    end

    def gemspec_file
      "#{@engine.project_name}.gemspec"
    end

    def check
      if !File.exist?(gemspec_file)
        @error = "I need a gemspec: #{gemspec_file}"
        return nil
      end

      if !File.exist?(gem_file)
        return nil
      end

      gem_file
    end

    def assert(executor)
      executor.run_command(["gem", "build", gemspec_file])
      gem_file
    end
  end
end
