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

    def gem_spec_file
      "#{@engine.project_name}.gemspec"
    end

    def check
      if !File.exist?(gem_spec_file)
        @error = "Couldn't find Gem spec '#{gem_spec_file}'"
        return nil
      end
      if !File.exist?(gem_file)
        return nil
      end
      gem_file
    end

    def assert(dry_run: false)
      if !dry_run
        `gem build #{gem_spec_file}`
      end
      gem_file
    end
  end
end
