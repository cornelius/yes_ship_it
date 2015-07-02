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

    def check
      if !File.exist?(gem_file)
        return nil
      end
      gem_file
    end

    def assert
      `gem build #{@engine.project_name}.gemspec`
      gem_file
    end
  end
end
