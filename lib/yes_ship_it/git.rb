module YSI
  class Git
    def initialize(executor, working_dir = Dir.pwd, branch = "master")
      @executor = executor
      @working_dir = working_dir
      @branch = branch
    end

    def run_git(args)
      Dir.chdir(@working_dir) do
        @executor.run_command(["git"] + args)
      end
    end

    def origin
      run_git(["remote", "-v"]).match(/origin\s+(.*?)(\.git)?\s+\(push\)/)[1]
    end

    def needs_push?
      local_master = run_git(["rev-parse", @branch])
      remote_master = run_git(["rev-parse", "origin/#{@branch}"])
      base = run_git(["merge-base", "master", "origin/#{@branch}"])

      remote_master == base && local_master != remote_master
    end

    def push
      run_git(["push"])
    end
  end
end
