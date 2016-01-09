describe Init do
  use_given_filesystem

  it "detects ruby" do
    path = given_directory("init/ruby")

    init = Init.new(path)

    expect(init.setup_config).to be(true)

    expected_config = <<-EOT
# Experimental release automation. See https://github.com/cornelius/yes_ship_it.
include:
  ruby_gem
EOT
    expect(File.read(File.join(path, "yes_ship_it.conf"))).to eq(expected_config)
  end
end
