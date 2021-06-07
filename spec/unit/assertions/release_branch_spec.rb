require_relative "../spec_helper.rb"

describe YSI::ReleaseBranch do
  describe "#current_branch" do
    it "finds current non-release branch" do
      a = YSI::ReleaseBranch.new(YSI::Engine)

      allow(a).to receive(:git_branch).and_return("  master\n* otherone\n")

      expect(a.current_branch).to eq("otherone")
    end

    it "finds current release branch" do
      a = YSI::ReleaseBranch.new(YSI::Engine)

      allow(a).to receive(:git_branch).and_return("* master\n otherone\n")

      expect(a.current_branch).to eq("master")
    end

    it "finds current release branch if it's the only branch" do
      a = YSI::ReleaseBranch.new(YSI::Engine)

      allow(a).to receive(:git_branch).and_return("* master\n")

      expect(a.current_branch).to eq("master")
    end

    it "reads branch parameter" do
      config = <<~YAML
        assertions:
          release_branch:
            branch: main
          version:
            version_file: lib/version.rb
      YAML
      engine = YSI::Engine.new
      engine.read_config(config)

      expect(engine.assertions.first.branch).to eq("main")
    end
  end
end
