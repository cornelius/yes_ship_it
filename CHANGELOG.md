# Change log of yes_ship_it

## Version 0.0.3

* Implement minimal version of `yes_ship_it init`. The init command is supposed
  to analyze an existing directory with code and create a suitable initial
  configuration for yes_ship_it. The current implementation simply assumes that
  it is a Ruby gem we are going to ship.
* Add assertion for submitting RPMs to the Open Build Service
* Add assertion for creating a release archive as tarball
* Support parsing version from a Go project
* Add assertion for clean working directory, which checks unstaged commits and
  untracked files
* Add assertion which checks that the local checkout is on the release branch.
  The default release branch is master.

## Version 0.0.2

* Don't run assertions when dependent assertions have failed
* Add support for including standard configs for certain scenarios. The first
  and only one for now is ruby_gems for releasing Ruby Gems.
* Add helper command `yes_ship_it changelog` to show the git log with all
  changes since last release as inspiration for the actual change log
* Check that the change log contains an entry for the version to be released

## Version 0.0.1

* Initial release
