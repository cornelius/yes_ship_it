require_relative "spec_helper.rb"

include GivenFilesystemSpecHelpers

describe YSI::Engine do
  use_given_filesystem

  describe "#class_for_assertion_name" do
    it "creates VersionNumber class" do
      expect(YSI::Engine.class_for_assertion_name("version")).
        to be(YSI::Version)
    end

    it "creates ChangeLog class" do
      expect(YSI::Engine.class_for_assertion_name("change_log")).
        to be(YSI::ChangeLog)
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

    ysi.run
  end
end
