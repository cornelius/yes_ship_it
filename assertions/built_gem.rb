module YSI
  class BuiltGem < Assertion
    attr_accessor :error

    def initialize(engine)
      @engine = engine
    end

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

    def assert(dry_run: false)
      if !dry_run
        `gem build #{gemspec_file}`
        if $?.to_i != 0
          return nil
        end
      end
      gem_file
    end
  end
end
