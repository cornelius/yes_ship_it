require_relative "../spec_helper.rb"

describe YSI::WorkingDirectory do
  describe "#status" do
    it "clean" do
      a = YSI::WorkingDirectory.new(YSI::Engine)

      git_output = <<EOT
# On branch master
# Your branch is ahead of 'origin/master' by 4 commits.
#   (use "git push" to publish your local commits)
#
nothing to commit, working directory clean
EOT
      allow(a).to receive(:git_status).and_return(git_output)

      expect(a.status).to eq("clean")
    end

    it "untracked files" do
      a = YSI::WorkingDirectory.new(YSI::Engine)

      git_output = <<EOT
# On branch master
# Your branch is ahead of 'origin/master' by 4 commits.
#   (use "git push" to publish your local commits)
#
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#
#       hello
nothing added to commit but untracked files present (use "git add" to track)
EOT
      allow(a).to receive(:git_status).and_return(git_output)

      expect(a.status).to eq("untracked files")
    end

    it "uncommitted changes" do
      a = YSI::WorkingDirectory.new(YSI::Engine)

      git_output = <<EOT
# On branch master
# Your branch is ahead of 'origin/master' by 4 commits.
#   (use "git push" to publish your local commits)
#
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#       new file:   hello
#
EOT
      allow(a).to receive(:git_status).and_return(git_output)

      expect(a.status).to eq("uncommitted changes")
    end

    it "unstaged changes" do
      a = YSI::WorkingDirectory.new(YSI::Engine)

      git_output = <<EOT
# On branch master
# Your branch is ahead of 'origin/master' by 4 commits.
#   (use "git push" to publish your local commits)
#
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#       modified:   README.md
#
no changes added to commit (use "git add" and/or "git commit -a")
EOT
      allow(a).to receive(:git_status).and_return(git_output)

      expect(a.status).to eq("unstaged changes")
    end
  end
end
