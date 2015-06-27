require_relative "spec_helper.rb"

include GivenFilesystemSpecHelpers

describe YSI::Engine do
  use_given_filesystem

  describe "#class_for_assertion_name" do
    it "creates VersionNumber class" do
      expect(YSI::Engine.class_for_assertion_name("version_number")).
        to be(YSI::VersionNumber)
    end

    it "creates ReleaseNotes class" do
      expect(YSI::Engine.class_for_assertion_name("release_notes")).
        to be(YSI::ReleaseNotes)
    end
  end

  it "reads configuration" do
    path = nil
    given_directory do
      path = given_file("yes_ship_it.conf")
    end

    ysi = YSI::Engine.new

    ysi.read(path)

    expect(ysi.assertions.count).to eq(2)
    expect(ysi.assertions[0].class).to eq(YSI::VersionNumber)
    expect(ysi.assertions[1].class).to eq(YSI::ReleaseNotes)
  end
end
