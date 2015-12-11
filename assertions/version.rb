module YSI
  class Version < Assertion
    parameter :version_file, "lib/version.rb"

    def display_name
      "version number"
    end

    def check
      if !File.exist?(version_file)
        @error = "Expected version in #{version_file}"
        return nil
      end

      version = parse_version(version_file)
      if version
        @engine.version = version
        return @engine.version
      end
      @error = "Couldn't find version in #{version_file}"
      nil
    end

    def assert(_executor)
    end

    def parse_version(file_name)
      if file_name =~ /\.rb$/
        File.read(file_name).each_line do |line|
          if line =~ /VERSION = "(.*)"/
            return $1
          end
        end
      elsif file_name =~ /\.go$/
        File.read(file_name).each_line do |line|
          if line =~ /Version = "(.*)"/
            return $1
          end
        end
      end
      nil
    end
  end
end
