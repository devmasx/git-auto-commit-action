def git_dirty?
  result = `git status -s`
  !result.empty?
end

# git_dirty?
repository = ENV.fetch("INPUT_REPOSITORY", ".")
file_pattern = ENV.fetch("INPUT_FILE_PATTERN", ".")
commit_message = ENV.fetch("INPUT_COMMIT_MESSAGE", "Auto commit")

github_actor = ENV.fetch("GITHUB_ACTOR", "")
github_token = ENV.fetch("GITHUB_TOKEN", "")
branch = ENV.fetch("INPUT_BRANCH", nil) ? ENV["INPUT_BRANCH"] : ENV["GITHUB_REF"].gsub("refs/heads/", "")

def github_auth
  File.open("#{ENV["HOME"]}/.netrc", "a") do |f|
    f << "
machine github.com
  login #{github_actor}
  password #{github_token}

machine github.com
  login #{github_actor}
  password #{github_token}
"
  end
  `git config --global user.email "actions@github.com"`
  `git config --global user.name "GitHub Actions"`
end

if git_dirty?
  github_auth
  `git add #{file_pattern}`
  `git commit -am "#{commit_message}"`
  `git push --set-upstream origin "HEAD:#{branch}"`
end
