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

    def http_post(url, data)
      begin
        RestClient.post(url, data)
      rescue RestClient::Exception => e
        raise YSI::AssertionError.new(e.message)
      end
    end

    def http_put(url, data, options)
      begin
        RestClient.put(url, data, options)
      rescue RestClient::Exception => e
        raise YSI::AssertionError.new(e.message)
      end
    end

    def http_delete(url)
      begin
        RestClient.delete(url)
      rescue RestClient::Exception => e
        raise YSI::AssertionError.new(e.message)
      end
    end
  end
end
