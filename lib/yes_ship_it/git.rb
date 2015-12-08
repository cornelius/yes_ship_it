module YSI
  class Git
    def initialize(working_dir = Dir.pwd)
      @working_dir = working_dir
    end

    def run_git(args)
      Dir.chdir(@working_dir) do
        `git #{args}`
      end
    end

    def origin
      run_git("remote -v").match(/origin\s+(.*)\s+\(push\)/)[1]
    end

    def needs_push?
      local_master = run_git("rev-parse master")
      remote_master = run_git("rev-parse origin/master")
      base = run_git("merge-base master origin/master")

      remote_master == base && local_master != remote_master
    end

    def push
      `git push`
    end
  end
end
