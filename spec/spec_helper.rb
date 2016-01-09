require "given_filesystem/spec_helpers"

include GivenFilesystemSpecHelpers

def setup_test_git_repo(version, dir)
  tarball = "spec/data/red_herring-#{version}.tar.gz"
  tarball_path = File.expand_path(tarball)
  if !system("cd #{dir}; tar xzf #{tarball_path}")
    raise "Unable to extract tarball #{tarball}"
  end
end
