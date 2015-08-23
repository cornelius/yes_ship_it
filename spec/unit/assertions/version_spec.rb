require_relative "../spec_helper.rb"

describe YSI::Version do
  it "has default path" do
    config = <<EOT
assertions:
  version:
EOT
    engine = YSI::Engine.new
    engine.read_config(config)

    expect(engine.assertions.first.version_file).to eq("lib/version.rb")
  end

  it "reads path parameter" do
    config = <<EOT
assertions:
  version:
    version_file: version.go
EOT
    engine = YSI::Engine.new
    engine.read_config(config)

    expect(engine.assertions.first.version_file).to eq("version.go")
  end
end
