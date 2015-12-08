module YSI
  class YesItShipped < Assertion
    def display_name
      "pushed to yes-it-shipped"
    end

    def check
      begin
        json = RestClient.get("https://yes-it-shipped.herokuapp.com/releases/#{engine.project_name}/#{engine.version}")
        return "#{engine.project_name}-#{engine.version}"
      rescue RestClient::ResourceNotFound
        return nil
      end
    end

    def assert(dry_run: false)
      if !dry_run
        begin
          RestClient.post("https://yes-it-shipped.herokuapp.com/releases",
            project: engine.project_name, version: engine.version,
            release_date_time: Time.now, project_url: engine.project_url,
            release_url: engine.release_url, ysi_config_url: engine.config_url)
        rescue RestClient::Exception
          return nil
        end
      end
      "#{engine.project_name}-#{engine.version}"
    end
  end
end
