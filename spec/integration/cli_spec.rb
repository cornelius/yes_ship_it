require_relative "spec_helper"

include CliTester

describe "command line interface" do
  it "runs" do
    expect(run_command).to exit_with_success("Shipping...\n")
  end
end
