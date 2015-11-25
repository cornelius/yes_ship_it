require_relative "spec_helper"

describe "ship ruby gem" do
  it "ships" do
    out = double
    allow(out).to receive(:puts)

    test = Httpotemkin::Test.new(out: out)
    test.add_server("rubygems")
    test.add_server("api.rubygems")
    test.add_server("obs")

    test.run do |client|
      client.install_gem_from_spec("yes_ship_it.gemspec")

      remote_tar = File.expand_path("../data/red_herring-remote.tar.gz", __FILE__)
      checkout_tar = File.expand_path("../data/red_herring-checkout.tar.gz", __FILE__)
      client.inject_tarball(remote_tar)
      client.inject_tarball(checkout_tar)

      client.execute(["yes_ship_it.ruby2.1"], working_directory: "red_herring")

      expect(client.exit_code).to eq(0)

      expected_output = <<EOT
Shipping...

Checking version number: 0.0.2
Checking tag: fail
Checking release archive: fail

Asserting tag: v0.0.2
Asserting release archive: red_herring-0.0.2.tar.gz

Shipped red_herring 0.0.2. Hooray!
EOT
      expect(client.out).to eq(expected_output)

      expect(client.err.empty?).to be(true)
    end
  end
end
