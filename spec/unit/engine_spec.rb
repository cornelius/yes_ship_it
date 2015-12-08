require_relative "spec_helper.rb"

include GivenFilesystemSpecHelpers

describe YSI::Engine do
  use_given_filesystem

  describe "#read_config" do
    it "reads valid configuration" do
      config = <<EOT
assertions:
  version:
EOT

      ysi = YSI::Engine.new
      ysi.read_config(config)
      expect(ysi.assertions.count).to eq(1)
      expect(ysi.assertions.first.class).to eq(YSI::Version)
    end
  end

  describe "#read" do
    it "reads valid configuration" do
      path = nil
      given_directory do
        path = given_file("yes_ship_it.conf")
      end

      ysi = YSI::Engine.new

      ysi.read(path)

      expect(ysi.assertions.count).to eq(2)
      expect(ysi.assertions[0].class).to eq(YSI::Version)
      expect(ysi.assertions[1].class).to eq(YSI::ChangeLog)
    end

    it "fails on configuration with unknown assertions" do
      path = nil
      given_directory do
        path = given_file("yes_ship_it.conf", from: "yes_ship_it.unknown.conf")
      end

      ysi = YSI::Engine.new

      expect {
        ysi.read(path)
      }.to raise_error YSI::Error
    end

    it "throws error when file does not exist" do
      ysi = YSI::Engine.new
      expect {
        ysi.read("/this/file/does/not/exist.conf")
      }.to raise_error Errno::ENOENT
    end
  end

  it "runs assertions" do
    path = nil
    given_directory do
      path = given_file("yes_ship_it.conf")
    end

    ysi = YSI::Engine.new

    ysi.read(path)

    ysi.assertions.each do |a|
      expect(a).to receive(:check)
    end

    ysi.out = StringIO.new

    ysi.run
  end

  it "runs assertion" do
    ysi = YSI::Engine.new

    expect_any_instance_of(YSI::Version).to receive(:check)

    ysi.check_assertion(YSI::Version)
  end

  it "provides tag" do
    ysi = YSI::Engine.new
    ysi.version = "1.2.3"

    expect(ysi.tag).to eq("v1.2.3")
  end

  it "loads standard config" do
    ysi_standard = YSI::Engine.new
    ysi_standard.read("configs/ruby_gem.conf")

    ysi = YSI::Engine.new
    ysi.read(given_file("yes_ship_it.include.conf"))

    expect(ysi.assertions.count).to be >= 6
    ysi_standard.assertions.each_with_index do |assertion, i|
      expect(assertion.class).to eq(ysi.assertions[i].class)
    end
  end

  describe "#dependency_errored?" do
    it "returns true, if no dependency errored" do
      engine = YSI::Engine.new
      errored_assertions = []
      assertion = YSI::ChangeLog.new(engine)
      expect(engine.dependency_errored?(assertion, errored_assertions)).to be(false)
    end

    it "returns false, if a dependency errored" do
      engine = YSI::Engine.new
      errored_assertions = [YSI::Version.new(engine)]
      assertion = YSI::ChangeLog.new(engine)
      expect(engine.dependency_errored?(assertion, errored_assertions)).to be(true)
    end
  end

  describe "release attributes" do
    before(:each) do
      @checkout_dir = given_directory
      setup_test_git_repo("005", @checkout_dir)
      @pwd = Dir.pwd
      Dir.chdir(File.join(@checkout_dir, "red_herring"))
      @engine = YSI::Engine.new
      @engine.version = "1.0.0"
    end

    after(:each) do
      Dir.chdir(@pwd)
    end

    it "#project_name" do
      expect(@engine.project_name).to eq("red_herring")
    end

    it "#project_url" do
      expect(@engine.project_url).to eq("https://github.com/cornelius/red_herring")
    end

    it "#release_url" do
      expect(@engine.release_url).to eq("https://github.com/cornelius/red_herring/releases/tag/v1.0.0")
    end

    it "#config_url" do
      expect(@engine.config_url).to eq("https://raw.githubusercontent.com/cornelius/red_herring/master/yes_ship_it.conf")
    end
  end
end
