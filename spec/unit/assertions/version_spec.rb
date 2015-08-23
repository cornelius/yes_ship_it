require_relative "../spec_helper.rb"

include GivenFilesystemSpecHelpers

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

  describe "parses version" do
    use_given_filesystem

    let(:subject) { YSI::Version.new(YSI::Engine.new) }

    it "in ruby" do
      file = given_file("version/version.rb")
      expect(subject.parse_version(file)).to eq("0.0.2")
    end

    it "in go" do
      file = given_file("version/version.go")
      expect(subject.parse_version(file)).to eq("0.0.1")
    end
  end
end
