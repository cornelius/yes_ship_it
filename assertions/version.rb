module YSI
  class Version < Assertion
    attr_accessor :error

    def initialize(engine)
      @engine = engine
    end

    def display_name
      "version number"
    end

    def check
      version_file = "lib/version.rb"
      if !File.exist?(version_file)
        @error = "Expected version in #{version_file}"
        return nil
      end

      File.read(version_file).each_line do |line|
        if line =~ /VERSION = "(.*)"/
          @engine.version = $1
          return @engine.version
        end
      end
      @error = "Couldn't find version in #{version_file}"
      nil
    end

    def assert
    end
  end
end
