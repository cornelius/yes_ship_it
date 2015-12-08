require_relative "spec_helper"

describe YSI::Git do
  it "#origin" do
    allow(subject).to receive(:run_git).with("remote -v").and_return(<<EOT
origin  git@github.com:cornelius/red_herring (fetch)
origin  git@github.com:cornelius/red_herring (push)
EOT
    )

    expect(subject.origin).to eq("git@github.com:cornelius/red_herring")
  end
end
