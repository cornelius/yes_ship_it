module YSI
  class ReleaseArchive < Assertion
    def display_name
      "release archive"
    end

    def git_revision
      `git rev-parse HEAD`.chomp
    end

    def filename
      "#{engine.project_name}-#{engine.version}.tar.gz"
    end

    def release_archive
      File.join(engine.data_dir, "release_archives", engine.project_name,
        git_revision, filename)
    end

    def check
      engine.release_archive = release_archive
      if File.exist?(release_archive)
        return filename
      end
      nil
    end

    def assert(dry_run: false)
      if !dry_run
        Dir.mktmpdir do |tmp_dir|
          archive_dir = "#{engine.project_name}-#{engine.version}"
          cmd = "git clone #{Dir.pwd} #{File.join(tmp_dir, archive_dir)} 2>/dev/null"
          system(cmd)
          FileUtils.mkdir_p(File.dirname(release_archive))
          excludes = [".git", ".gitignore", "yes_ship_it.conf"]
          exclude_options = excludes.map { |e| "--exclude '#{e}'" }.join(" ")
          if !system("cd #{tmp_dir}; tar czf #{release_archive} #{exclude_options} #{archive_dir}")
            return nil
          end
        end
      end
      filename
    end
  end
end
