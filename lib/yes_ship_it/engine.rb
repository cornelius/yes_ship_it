module YSI
  class Engine
    attr_reader :assertions
    attr_accessor :version, :tag_date, :release_archive
    attr_accessor :out
    attr_accessor :dry_run
    attr_accessor :data_dir

    def initialize
      @assertions = []
      @out = STDOUT
      @data_dir = File.expand_path("~/.ysi")
    end

    def read_config(yaml)
      config = YAML.load(yaml)
      parse(config)
    end

    def read(filename)
      config = YAML.load_file(filename)
      parse(config)
    end

    def parse(config)
      config.each do |key,value|
        if key == "include"
          included_file = value
          configs_path = File.expand_path("../../../configs", __FILE__)
          read(File.join(configs_path, included_file + ".conf"))
        elsif key == "assertions"
          assertions = value
          if assertions
            assertions.each do |assertion_name, parameters|
              if assertion_name == "version_number"
                out.puts "Warning: use `version` instead of `version_number`."
                out.puts
                assertion_name = "version"
              end

              assertion = YSI::Assertion.class_for_name(assertion_name).new(self)
              if parameters
                parameters.each do |parameter_name, parameter_value|
                  assertion.send(parameter_name + "=", parameter_value)
                end
              end
              @assertions << assertion
            end
          end
        end
      end
    end

    def check_assertion(assertion_class)
      assertion_class.new(self).check
    end

    def project_name
      File.basename(Dir.pwd)
    end

    def tag
      "v#{version}"
    end

    def release_archive_file_name
      File.basename(release_archive)
    end

    def dependency_errored?(assertion, errored_assertions)
      assertion.needs.each do |need|
        errored_assertions.each do |errored_assertion|
          if errored_assertion.class == need
            return true
          end
        end
      end
      false
    end

    def run
      failed_assertions = []
      errored_assertions = []
      skipped_assertions = []

      @assertions.each do |assertion|
        out.print "Checking #{assertion.display_name}: "
        if dependency_errored?(assertion, errored_assertions) ||
           dependency_errored?(assertion, skipped_assertions)
          out.puts "skip (because dependency errored)"
          skipped_assertions << assertion
          next
        end
        success = assertion.check
        if success
          out.puts success
        else
          if assertion.error
            out.puts "error"
            out.puts "  " + assertion.error
            errored_assertions.push(assertion)
          else
            out.puts "fail"
            failed_assertions.push(assertion)
          end
        end
      end

      out.puts

      if !errored_assertions.empty?
        out.puts "Couldn't ship #{project_name}. Help me."
        return 1
      else
        if failed_assertions.empty?
          if tag_date
            out.puts "#{project_name} #{version} already shipped on #{tag_date}"
          else
            out.puts "#{project_name} #{version} already shipped"
          end
          return 0
        else
          failed_assertions.each do |assertion|
            if dry_run
              out.print "Dry run: "
            end
            out.print "Asserting #{assertion.display_name}: "
            success = assertion.assert(dry_run: dry_run)
            if !success
              out.puts
              out.puts "Ran into an error. Stopping shipping."
              return 1
            end
            out.puts success
          end

          out.puts
          if dry_run
            out.puts "Did a dry run of shipping #{project_name} #{version}." +
              " Nothing was changed."
          else
            out.puts "Shipped #{project_name} #{version}. Hooray!"
          end
          return 0
        end
      end
    end
  end
end
