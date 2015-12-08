module YSI
  class Git
    def run_git(args)
      `git #{args}`
    end

    def origin
      run_git("remote -v").match(/origin\s+(.*)\s+\(push\)/)[1]  
    end
  end
end
