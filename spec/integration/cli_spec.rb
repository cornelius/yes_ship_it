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
Checking change log: skip (because dependency errored)

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

    it "skips assertions with errored dependencies" do
      dir = nil
      given_directory do
        dir = given_directory "test_project" do
          given_file("yes_ship_it.conf", from: "yes_ship_it.include.conf")
        end
        system("cd #{dir}; git init >/dev/null")
      end

      expected_output = <<EOT
Shipping...

Checking release branch: error
  Not on release branch 'master'
Checking working directory: error
  untracked files
Checking version number: error
  Expected version in lib/version.rb
Checking change log: skip (because dependency errored)
Checking tag: skip (because dependency errored)
Checking built gem: error
  I need a gemspec: test_project.gemspec
Checking published gem: skip (because dependency errored)
Checking pushed tag: skip (because dependency errored)

Couldn't ship test_project. Help me.
EOT

      expect(run_command(working_directory: dir)).
        to exit_with_error(1, "", expected_output)
    end

    it "creates release archive" do
      git_dir = given_directory
      setup_test_git_repo("006", git_dir)

      data_dir = given_directory

      expected_output = <<EOT
Shipping...

Checking version number: 0.0.2
Checking tag: fail
Checking release archive: fail

Asserting tag: v0.0.2
Asserting release archive: red_herring-0.0.2.tar.gz

Shipped red_herring 0.0.2. Hooray!
EOT

      expect(run_command(args: ["--data-dir=#{data_dir}"],
        working_directory: File.join(git_dir, "red_herring"))).
        to exit_with_success(expected_output)

      release_archive = File.join(data_dir, "release_archives", "red_herring",
        "4ba08cb0f26d813cd754bc9ccb9f89274f24f2b6",
        "red_herring-0.0.2.tar.gz")

      expect(File.exist?(File.join(git_dir, "red_herring", "red_herring-0.0.2"))).to be(false)

      expect(File.exist?(release_archive)).to be(true)

      expected_file_list = <<EOT
red_herring-0.0.2/
red_herring-0.0.2/bin/
red_herring-0.0.2/bin/tickle
red_herring-0.0.2/CHANGELOG.md
red_herring-0.0.2/Gemfile
red_herring-0.0.2/red_herring.gemspec
red_herring-0.0.2/MIT-LICENSE
red_herring-0.0.2/README.md
red_herring-0.0.2/lib/
red_herring-0.0.2/lib/red_herring.rb
red_herring-0.0.2/lib/version.rb
EOT
      file_list = `tar tzf #{release_archive}`.split("\n").sort
      expect(file_list).to eq(expected_file_list.split("\n").sort)
    end
  end

  describe "changelog helper" do
    it "shows changelog since last version" do
      dir = given_directory

      setup_test_git_repo("005", dir)

      expected_output = <<EOT
commit 22cb6af3f7ea8385a8d0c62340c99265e0c8a63d
Author: Cornelius Schumacher <schumacher@kde.org>
Date:   Fri Jul 10 23:54:01 2015 +0200

    Implement magic method

commit 40ec45663e2a3cf32895b451cc43e667463af431
Author: Cornelius Schumacher <schumacher@kde.org>
Date:   Fri Jul 10 23:50:08 2015 +0200

    Add magic method
EOT

      expect(run_command(args: ["changelog"],
        working_directory: File.join(dir, "red_herring"))).
        to exit_with_success(expected_output)
    end
  end
end
