require_relative "spec_helper"

include CliTester
include GivenFilesystemSpecHelpers

describe "command line interface" do
  use_given_filesystem(keep_files: true)

  it "does not find yes_ship_it.conf" do
    dir = given_directory
    expect(run_command(working_directory: dir)).to exit_with_error(1, /yes_ship_it.conf/)
  end

  describe "runs" do
    it "fails when version is not there" do
      dir = given_directory

      setup_test_git_repo("000", dir)

      expected_output = <<EOT
Shipping...

Warning: use `version` instead of `version_number`.

Checking version number: error
  Expected version in lib/version.rb
Checking change log: error
  Expected change log in CHANGELOG.md

Couldn't ship red_herring. Help me.
EOT

      expect(run_command(working_directory: File.join(dir, "red_herring"))).
        to exit_with_error(1, "", expected_output)
    end

    it "succeeds when all checks are met" do
      dir = given_directory

      setup_test_git_repo("001", dir)

      expected_output = <<EOT
Shipping...

Warning: use `version` instead of `version_number`.

Checking version number: 0.0.1
Checking change log: CHANGELOG.md

red_herring 0.0.1 already shipped
EOT

      expect(run_command(working_directory: File.join(dir, "red_herring"))).
        to exit_with_success(expected_output)
    end

    it "succeeds when tag is there" do
      dir = given_directory

      setup_test_git_repo("002", dir)

      expected_output = <<EOT
Shipping...

Warning: use `version` instead of `version_number`.

Checking version number: 0.0.1
Checking change log: CHANGELOG.md
Checking tag: v0.0.1

red_herring 0.0.1 already shipped on Wed Jul 1 00:46:19 2015 +0200
EOT

      expect(run_command(working_directory: File.join(dir, "red_herring"))).
        to exit_with_success(expected_output)
    end

    it "fails when gem is not built" do
      dir = given_directory

      setup_test_git_repo("003", dir)

      expected_output = <<EOT
Shipping...

Checking version number: 0.0.1
Checking change log: CHANGELOG.md
Checking built gem: fail
Checking tag: v0.0.1

Asserting built gem: red_herring-0.0.1.gem

Shipped red_herring 0.0.1. Hooray!
EOT

      expect(run_command(working_directory: File.join(dir, "red_herring"))).
        to exit_with_success(expected_output)
    end

    it "processes the --dry-run option" do
      dir = given_directory

      setup_test_git_repo("003", dir)

      expected_output = <<EOT
Shipping...

Checking version number: 0.0.1
Checking change log: CHANGELOG.md
Checking built gem: fail
Checking tag: v0.0.1

Dry run: Asserting built gem: red_herring-0.0.1.gem

Did a dry run of shipping red_herring 0.0.1. Nothing was changed.
EOT

      expect(run_command(args: ["--dry-run"],
        working_directory: File.join(dir, "red_herring"))).
        to exit_with_success(expected_output)
    end

    it "checks the change log" do
      dir = given_directory

      setup_test_git_repo("004", dir)

      expected_output = <<EOT
Shipping...

Checking version number: 0.0.2
Checking change log: error
  Can't find version 0.0.2 in change log
Checking built gem: fail
Checking tag: fail

Couldn't ship red_herring. Help me.
EOT

      expect(run_command(working_directory: File.join(dir, "red_herring"))).
        to exit_with_error(1, "", expected_output)
    end
  end
end
