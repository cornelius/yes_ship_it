module YSI
  class YesItShipped < Assertion
    needs "tag"

    def self.display_name
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

    def assert(executor)
      executor.http_post("https://yes-it-shipped.herokuapp.com/releases",
        project: engine.project_name, version: engine.version,
        release_date_time: engine.tag_date.utc, project_url: engine.project_url,
        release_url: engine.release_url, ysi_config_url: engine.config_url)
      "#{engine.project_name}-#{engine.version}"
    end
  end
end
