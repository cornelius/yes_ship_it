require_relative "../spec_helper.rb"

describe YSI::ReleaseBranch do
  describe "#current_branch" do
    it "finds current non-master branch" do
      a = YSI::ReleaseBranch.new(YSI::Engine)

      allow(a).to receive(:git_branch).and_return("  master\n* otherone\n")

      expect(a.current_branch).to eq("otherone")
    end

    it "finds current master branch" do
      a = YSI::ReleaseBranch.new(YSI::Engine)

      allow(a).to receive(:git_branch).and_return("* master\n otherone\n")

      expect(a.current_branch).to eq("master")
    end

    it "finds current master branch if it's the only branch" do
      a = YSI::ReleaseBranch.new(YSI::Engine)

      allow(a).to receive(:git_branch).and_return("* master\n")

      expect(a.current_branch).to eq("master")
    end
  end
end
