require_relative "../spec_helper"

describe YSI::YesItShipped do
  describe "#check" do
    it "succeeds when release is there" do
      body = <<-EOT
{
  "id": 2,
  "project": "dummy",
  "project_url": "http://example.com/dummy",
  "version": "1.0.0",
  "release_date_time": "2015-12-07T17:56:00.000Z",
  "release_url": "http://example.com/dummy/v0.1.0",
  "ysi_config_url": "http://example.com/dummy/yes_ship_it.conf",
  "created_at": "2015-12-08T11:37:33.884Z",
  "updated_at": "2015-12-08T11:37:33.884Z"
}
EOT
      stub_request(:get, "https://yes-it-shipped.herokuapp.com/releases/dummy/1.0.0").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>/.*/, 'Host'=>'yes-it-shipped.herokuapp.com', 'User-Agent'=>/.*/}).
         to_return(:status => 200, :body => body, :headers => {})

      engine = YSI::Engine.new
      allow(engine).to receive(:project_name).and_return("dummy")
      engine.version = "1.0.0"
      assertion = YSI::YesItShipped.new(engine)
      expect(assertion.check).to eq("dummy-1.0.0")
    end

    it "fails when release is not there" do
      stub_request(:get, "https://yes-it-shipped.herokuapp.com/releases/dummy/2.0.0").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>/.*/, 'Host'=>'yes-it-shipped.herokuapp.com', 'User-Agent'=>/.*/}).
         to_return(:status => 404, :body => "", :headers => {})

      engine = YSI::Engine.new
      allow(engine).to receive(:project_name).and_return("dummy")
      engine.version = "2.0.0"
      assertion = YSI::YesItShipped.new(engine)
      expect(assertion.check).to be_nil
    end
  end

  describe "#assert" do
    it "pushes release" do
      stub_request(:post, "https://yes-it-shipped.herokuapp.com/releases").
        with(
          :body => {
            "project"=>"dummy",
            "project_url"=>"https://github.com/cornelius/yes_ship_it",
            "release_date_time"=>"2015-12-08 13:16:55 UTC",
            "release_url"=>"https://github.com/cornelius/yes_ship_it/releases/tag/v1.1.1",
            "version"=>"1.1.1",
            "ysi_config_url"=>"https://raw.githubusercontent.com/cornelius/yes_ship_it/master/yes_ship_it.conf"
          },
          :headers => {
            'Accept'=>'*/*',
            'Accept-Encoding'=> /.*/,
            'Content-Length'=>'334',
            'Content-Type'=>'application/x-www-form-urlencoded',
            'Host'=>'yes-it-shipped.herokuapp.com',
            'User-Agent' => /.*/
          }).to_return(:status => 200, :body => "", :headers => {})

      engine = YSI::Engine.new
      allow(engine).to receive(:project_name).and_return("dummy")
      allow(engine).to receive(:github_project_name).and_return("cornelius/yes_ship_it")
      engine.version = "1.1.1"
      engine.tag_date = Time.parse("20151208T141655+0100")

      assertion = YSI::YesItShipped.new(engine)

      expect(assertion.assert(engine.executor)).to eq("dummy-1.1.1")
    end
  end

  it "reads yis_server_url parameter" do
    config = <<EOT
assertions:
  yes_it_shipped:
    yis_server_url: http://localhost:3000
EOT
    engine = YSI::Engine.new
    engine.read_config(config)

    expect(engine.assertions.first.yis_server_url).to eq("http://localhost:3000")
  end

  it "has default yis_server_url parameter" do
    config = <<EOT
assertions:
  yes_it_shipped:
EOT
    engine = YSI::Engine.new
    engine.read_config(config)

    expect(engine.assertions.first.yis_server_url).to eq("https://yes-it-shipped.herokuapp.com")
  end
end
