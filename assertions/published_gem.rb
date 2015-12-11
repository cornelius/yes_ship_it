module YSI
  class PublishedGem < Assertion
    needs "built_gem"

    def display_name
      "published gem"
    end

    def gem_file
      "#{@engine.project_name}-#{@engine.version}.gem"
    end

    def check
      begin
        json = RestClient.get("https://rubygems.org/api/v1/versions/#{engine.project_name}.json")
      rescue RestClient::ResourceNotFound
        return nil
      end
      versions = JSON.parse(json)
      versions.each do |version|
        if version["number"] == @engine.version
          return @engine.version
        end
      end
      nil
    end

    def assert(executor)
      if !File.exist?(File.expand_path("~/.gem/credentials"))
        raise AssertionError.new("You need to log in to Rubygems first by running `gem push #{gem_file}` manually")
      end

      executor.run_command(["gem", "push", gem_file])

      gem_file
    end
  end
end
