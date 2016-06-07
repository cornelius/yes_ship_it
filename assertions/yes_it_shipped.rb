module YSI
  class YesItShipped < Assertion
    needs "tag"

    parameter :yis_server_url, "https://yes-it-shipped.herokuapp.com"

    def self.display_name
      "pushed to yes-it-shipped"
    end

    def check
      begin
        RestClient.get("#{yis_server_url}/releases/#{engine.project_name}/#{engine.version}")
        return "#{engine.project_name}-#{engine.version}"
      rescue RestClient::ResourceNotFound
        return nil
      end
    end

    def assert(executor)
      executor.http_post("#{yis_server_url}/releases",
        project: engine.project_name, version: engine.version,
        release_date_time: engine.tag_date, project_url: engine.project_url,
        release_url: engine.release_url, ysi_config_url: engine.config_url)
      "#{engine.project_name}-#{engine.version}"
    end
  end
end
