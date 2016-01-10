module YSI
  class Version < Assertion
    parameter :version_file, "lib/version.rb"

    def self.display_name
      "version number"
    end

    def check
      if !File.exist?(version_file)
        raise AssertionError.new("Expected version in #{version_file}")
      end

      version = parse_version(version_file)
      if version
        @engine.version = version
        return @engine.version
      end
      raise AssertionError.new("Couldn't find version in #{version_file}")
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
      elsif file_name =~ /\.h$/
        File.read(file_name).each_line do |line|
          if line =~ /#define .*_VERSION "(.*)"/
            return $1
          end
        end
      end
      nil
    end
  end
end
