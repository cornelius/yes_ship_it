require_relative "spec_helper"

describe "rpm" do
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

  it "pushes to obs" do
    checkout_tar = File.expand_path("../data/red_herring-checkout-rpm.tar.gz", __FILE__)
    @client.inject_tarball(checkout_tar)

    @client.execute(["yes_ship_it.ruby2.5"], working_directory: "red_herring")

    expected_output = <<EOT
Shipping...

Checking release branch: master
Checking working directory: clean
Checking version number: 0.0.2
Checking change log: CHANGELOG.md
Checking tag: fail
Checking release archive: fail
Checking submitted RPM: fail
Checking pushed tag: fail
Checking pushed code: fail

Asserting tag: v0.0.2
Asserting release archive: red_herring-0.0.2.tar.gz
Asserting submitted RPM: ...
  Uploading release archive 'red_herring-0.0.2.tar.gz'
  Uploading spec file 'red_herring.spec'
... home:cschum:go/red_herring
Asserting pushed tag: v0.0.2
Asserting pushed code: pushed

Shipped red_herring 0.0.2. Hooray!
EOT
    expect(@client.err).to eq("")
    expect(@client.out).to eq(expected_output)
    expect(@client.exit_code).to eq(0)
  end
end
