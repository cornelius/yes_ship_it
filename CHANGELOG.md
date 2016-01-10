# Change log of yes_ship_it

## Version 0.1.1

* Fix failure in `yes_it_shipped` assertion when parsing tag date

## Version 0.1.0

yes_ship_it has reached a useful state, so it's going to a version scheme which
will distinguish feature and bug fix releases. It's not API stable yet, so it's
still using 0.x releases.

Changes in this version:

* Add documentation for `plugin` command

## Version 0.0.6

* Add support for local assertion plugins. `yes_ship_it plugin generate` creates
  the scaffold for a new plugin. `yes_ship_it plugin list` shows all available
  local plugins.
* Support reading versions from C/C++ header files
* Don't overwrite existing config with `yes_ship_it init` (bug #5)
* Implement detection of ruby and generic projects in `yes_ship_it init`
* Support `obs_project` parameter in `submitted_rpm` assertion

## Version 0.0.5

* Handle missing credentials for Rubygems, when pushing gems
* Handle the case when the origin in your git configuration includes the .git
  extension
* When pushing to yes_it_shipped use the date is when the release happened not
  when the release was pushed to the site (Issue #9)
* Add assertion `pushed_code` to check, if the released has been pushed to the
  remote repository

## Version 0.0.4

* Add yes_it_shipped assertion

  This assertion publishes the release on a central server we have set up for
  the yes_ship_it project. It currently runs at
  https://yes-it-shipped.herokuapp.com.

  The assertion is used, if you either explicitly put it in your configuration
  or if you include the `rubygems` template.

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
