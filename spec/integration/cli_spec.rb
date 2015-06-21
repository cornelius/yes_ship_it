require_relative "spec_helper"

include CliTester
include GivenFilesystemSpecHelpers

describe "command line interface" do
  use_given_filesystem

  it "does not find yes_ship_it.conf" do
    dir = given_directory
    expect(run_command(working_directory: dir)).to exit_with_error(1, /yes_ship_it.conf/)
  end

  it "runs" do
    dir = given_directory do
      given_file("yes_ship_it.conf")
    end
    expect(run_command(working_directory: dir)).to exit_with_success("Shipping...\n")
  end
end
