require_relative "../spec_helper"

include GivenFilesystemSpecHelpers

describe YSI::PushedCode do
  use_given_filesystem

  it "pushes code" do
    expect_any_instance_of(YSI::Git).to receive(:push).and_return("pushed")
    dir = given_directory
    setup_test_git_repo("007", dir)

    engine = YSI::Engine.new
    assertion = YSI::PushedCode.new(engine)
    Dir.chdir(File.join(dir, "red_herring")) do
      expect(assertion.check).to be(nil)
      expect(assertion.assert).to eq "pushed"
    end
  end
end
