module YSI
  class Git
    def initialize(executor, working_dir = Dir.pwd)
      @executor = executor
      @working_dir = working_dir
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
      branch = run_git(["branch"]).split("\n").find { |x| x.strip.start_with?("*")}
      branch = branch.strip[1..-1].strip
      local_branch = run_git(["rev-parse", branch])
      remote_branch = run_git(["rev-parse", "origin/#{branch}"])
      base = run_git(["merge-base", branch, "origin/#{branch}"])

      remote_branch == base && local_branch != remote_branch
    end

    def push
      run_git(["push"])
    end
  end
end
