require_relative "spec_helper"

describe YSI::Init do
  use_given_filesystem

  it "falls back to generic project if it can not detect type" do
    path = given_directory

    init = YSI::Init.new(path)
    out = double
    allow(out).to receive(:puts)
    init.out = out
    init.setup_config

    expected_config = <<-EOT
# Experimental release automation. See https://github.com/cornelius/yes_ship_it.
assertions:
  - release_branch
  - working_directory
  - version
  - change_log
  - tag
  - pushed_tag
  - pushed_code
  - yes_it_shipped
EOT
    expect(File.read(File.join(path, "yes_ship_it.conf"))).to eq(expected_config)
  end

  it "detects ruby" do
    path = nil
    given_directory("init") do
      path = given_directory_from_data("ruby", from: "init/ruby" )
    end

    init = YSI::Init.new(path)
    out = double
    allow(out).to receive(:puts)
    init.out = out
    init.setup_config

    expected_config = <<-EOT
# Experimental release automation. See https://github.com/cornelius/yes_ship_it.
include:
  ruby_gem
EOT
    expect(File.read(File.join(path, "yes_ship_it.conf"))).to eq(expected_config)
  end
end
