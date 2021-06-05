require_relative "spec_helper"

describe "dry run" do
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

  it "doesn't do changes" do
    checkout_tar = File.expand_path("../data/red_herring-checkout-dry-run.tar.gz", __FILE__)
    @client.inject_tarball(checkout_tar)

    @client.execute(["yes_ship_it.ruby2.5", "--dry-run"], working_directory: "red_herring")

    expected_output = <<EOT
Shipping...

Checking release branch: master
Checking working directory: clean
Checking version number: 0.0.2
Checking change log: CHANGELOG.md
Checking tag: fail
Checking built gem: fail
Checking published gem: fail
Checking pushed tag: fail
Checking pushed code: fail

Dry run: Asserting tag: v0.0.2
Dry run: Asserting built gem: red_herring-0.0.2.gem
Dry run: Asserting published gem: red_herring-0.0.2.gem
Dry run: Asserting pushed tag: v0.0.2
Dry run: Asserting pushed code: pushed

Did a dry run of shipping red_herring 0.0.2. Nothing was changed.
EOT
    expect(@client.err).to eq("")
    expect(@client.out).to eq(expected_output)
    expect(@client.exit_code).to eq(0)
  end
end
