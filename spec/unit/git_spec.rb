require_relative "spec_helper"

include GivenFilesystemSpecHelpers

describe YSI::Git do
  describe "#origin" do

    it "grabs the url without the extension" do
      allow(subject).to receive(:run_git).with("remote -v").and_return(<<EOT
origin  git@github.com:cornelius/red_herring (fetch)
origin  git@github.com:cornelius/red_herring (push)
EOT
      )
      expect(subject.origin).to eq("git@github.com:cornelius/red_herring")
    end

    it "grabs the url with the extension" do
      allow(subject).to receive(:run_git).with("remote -v").and_return(<<EOT
origin  git@github.com:cornelius/red_herring.git (fetch)
origin  git@github.com:cornelius/red_herring.git (push)
EOT
      )
      expect(subject.origin).to eq("git@github.com:cornelius/red_herring")
    end
  end

  describe "#needs_push?" do
    use_given_filesystem

    it "returns true if local changes are not in remote branch" do
      dir = given_directory
      setup_test_git_repo("007", dir)
      git = YSI::Git.new(File.join(dir, "red_herring"))

      expect(git.needs_push?).to be(true)
    end

    it "returns false if local changes are in remote branch" do
      dir = given_directory
      setup_test_git_repo("008", dir)
      git = YSI::Git.new(File.join(dir, "red_herring"))

      expect(git.needs_push?).to be(false)
    end
  end
end
