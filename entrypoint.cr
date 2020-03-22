class App
  @repository : String
  @file_pattern : String
  @commit_message : String
  @github_actor : String
  @github_token : String
  @branch : String

  def self.git_dirty?
    result = `git status -s`
    !result.empty?
  end

  def initialize
    @repository = ENV.fetch("INPUT_REPOSITORY", ".")
    @file_pattern = ENV.fetch("INPUT_FILE_PATTERN", ".")
    @commit_message = ENV.fetch("INPUT_COMMIT_MESSAGE", "Auto commit")

    @github_actor = ENV.fetch("GITHUB_ACTOR", "")
    @github_token = ENV.fetch("GITHUB_TOKEN", "")
    @branch = set_brach
  end

  def set_brach
    branch = ENV.fetch("INPUT_BRANCH", "")
    if branch == ""
      ENV["GITHUB_REF"].gsub("refs/heads/", "")
    else
      branch
    end
  end

  def write_auth_file
    File.open("#{ENV["HOME"]}/.netrc", "a") do |f|
      f << "
machine github.com
login #{@github_actor}
password #{@github_token}

machine github.com
login #{@github_actor}
password #{@github_token}
"
    end
  end

  def github_auth
    write_auth_file
    `git config --global user.email "actions@github.com"`
    `git config --global user.name "GitHub Actions"`
  end

  def auto_commit
    puts "Auto commit run #{App.git_dirty?} branch: #{@branch}"
    if App.git_dirty?
      github_auth
      `git add #{@file_pattern}`
      `git commit -am "#{@commit_message}"`
      `git push --set-upstream origin "HEAD:#{@branch}"`
    end
  end
end

App.new.auto_commit
