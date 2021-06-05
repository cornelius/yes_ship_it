require_relative "spec_helper"

describe "ship ruby gem" do
  before(:all) do
    out = StringIO.new
    @test = Httpotemkin::Test.new(out: out)
    @test.add_server("rubygems")
    @test.add_server("api.rubygems")
    @test.add_server("obs")
    @test.up
  end

  after(:all) do
    @test.down
  end

  before(:each) do
    @client = @test.start_client
    @client.install_gem_from_spec("yes_ship_it.gemspec")
    remote_tar = File.expand_path("../data/red_herring-remote.tar.gz", __FILE__)
    @client.inject_tarball(remote_tar)
  end

  after(:each) do
    @test.stop_client
  end

  context "with existing credentials" do
    it "builds gem" do
      checkout_tar = File.expand_path("../data/red_herring-checkout-build.tar.gz", __FILE__)
      @client.inject_tarball(checkout_tar)

      @client.execute(["yes_ship_it.ruby2.5"], working_directory: "red_herring")

      expect(@client.exit_code).to eq(0)

      expected_output = <<EOT
Shipping...

Checking version number: 0.0.2
Checking tag: fail
Checking release archive: fail

Asserting tag: v0.0.2
Asserting release archive: red_herring-0.0.2.tar.gz

Shipped red_herring 0.0.2. Hooray!
EOT
      expect(@client.out).to eq(expected_output)

      expect(@client.err).to eq("")
    end

    it "pushes gem if it isn't pushed yet" do
      checkout_tar = File.expand_path("../data/red_herring-checkout-push.tar.gz", __FILE__)
      @client.inject_tarball(checkout_tar)

      @client.execute(["yes_ship_it.ruby2.5"], working_directory: "red_herring")

      expect(@client.exit_code).to eq(0)

      expected_output = <<EOT
Shipping...

Checking version number: 0.0.2
Checking tag: fail
Checking built gem: fail
Checking published gem: fail

Asserting tag: v0.0.2
Asserting built gem: red_herring-0.0.2.gem
Asserting published gem: red_herring-0.0.2.gem

Shipped red_herring 0.0.2. Hooray!
EOT

      expect(@client.out).to eq(expected_output)

      expect(@client.err).to eq("")
    end

    it "doesn't push gem if it already is pushed" do
      checkout_tar = File.expand_path("../data/red_herring-checkout-not-push.tar.gz", __FILE__)
      @client.inject_tarball(checkout_tar)

      @client.execute(["yes_ship_it.ruby2.5"], working_directory: "red_herring")

      expect(@client.exit_code).to eq(0)

      expected_output = <<EOT
Shipping...

Checking version number: 0.0.1
Checking built gem: red_herring-0.0.1.gem
Checking published gem: 0.0.1

red_herring 0.0.1 already shipped
EOT
      expect(@client.out).to eq(expected_output)

      expect(@client.err.empty?).to be(true)
    end
  end

  context "without existing credentials" do
    before(:each) do
      @client.execute(["mv", "/root/.gem/credentials", "/tmp"])

      checkout_tar = File.expand_path("../data/red_herring-checkout-push.tar.gz", __FILE__)
      @client.inject_tarball(checkout_tar)
    end

    after(:each) do
      @client.execute(["mv", "/tmp/credentials", "/root/.gem/"])
    end

    it "tells how to login" do
      @client.execute(["yes_ship_it.ruby2.5"], working_directory: "red_herring")

      expected_output = <<EOT
Shipping...

Checking version number: 0.0.2
Checking tag: fail
Checking built gem: fail
Checking published gem: fail

Asserting tag: v0.0.2
Asserting built gem: red_herring-0.0.2.gem
Asserting published gem: error
  You need to log in to Rubygems first by running `gem push red_herring-0.0.2.gem` manually

Ran into an error. Stopping shipping.
EOT
      expect(@client.err).to eq("")
      expect(@client.out).to eq(expected_output)
      expect(@client.exit_code).to eq(1)
    end
  end
end
