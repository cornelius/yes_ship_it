module YSI
  class Executor
    def run_command(args, working_directory: Dir.pwd)
      begin
        Dir.chdir(working_directory) do
          Cheetah.run(args, stdout: :capture)
        end
      rescue Cheetah::ExecutionFailed => e
        raise YSI::AssertionError.new(e.message)
      end
    end
  end
end
