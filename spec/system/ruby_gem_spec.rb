require_relative "spec_helper"

describe "ship ruby gem" do
  it "ships" do
    test = Httpotemkin::Test.new
    test.add_server("rubygems")
    test.add_server("api.rubygems")
    test.add_server("obs")

    test.run do |client|
      client.install_gem_from_spec("yes_ship_it.gemspec")
      client.inject_tarball("red_herring-remote.tar.gz")
      client.inject_tarball("red_herring-checkout.tar.gz")

      client.execute("yes_ship_it", working_dir: "red_herring")

      expect(client.exit_code).to eq(0)
      expect(client.out).to eq("success")
      expect(client.err.empty?).to be(true)
    end
  end
end
