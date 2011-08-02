module GithubPulley
  class Base
    def initialize
      @octokit = Octokit::Client.new(:login => github_user, :token => github_token)
    end

    def get_open_issues(opts={})
      # Listing by assignee seems to be broken
      all_open_issues.each do |issue|
        print_issue(issue)
      end
    end

    def attach_pull_request_to_issue(issue, opts={})
      opts = {
        :base => 'master',
        :head => "#{origin_user}:#{current_branch}",
        :branch => current_branch
      }.merge(opts)
      p opts
      puts "Pushing to #{opts[:branch]} on 'origin'"
      `git push origin #{opts[:branch]}`
      pull_to = forked_from || origin_repo
      # @octokit.create_pull_request_for_issue(repo, base, head, issue, options={})
      # Returns nil if successfull
      @octokit.create_pull_request_for_issue(pull_to, opts[:base], opts[:head], issue)

      issue_details = @octokit.issue(repo, issue)
      print_issue(issue_details, "Attached to")
    end

    def create_pull_request(title, body='', opts={})
      opts = {
        :base => 'master',
        :head => "#{origin_user}:#{current_branch}",
        :branch => current_branch
      }.merge(opts)
      puts "Pushing to #{opts[:branch]} on 'origin'"
      `git push origin #{opts[:branch]}`
      pull_to = forked_from || origin_repo
      @octokit.create_pull_request(pull_to, opts[:base], opts[:head], title, body)
      # Returns nil if successfull
      puts "Created new pull request"
    end

    private

    def all_open_issues
      @octokit.get("/api/v2/json/issues/list/#{Octokit::Repository.new(repo)}/open")['issues']
    end

    def github_user
      @github_user ||= `git config github.user`.strip
      raise Error, "Please set github.user" if @github_user.empty?
      @github_user
    end

    def github_token
      @github_token ||= `git config github.token`.strip
      raise Error, "Please set github.token" if @github_token.empty?
      @github_token
    end

    def current_branch
      `git name-rev HEAD 2> /dev/null | awk "{ print \\$2 }"`.strip
    end

    def forked_from
      @octokit.repository(origin_repo)['source']
    end

    def repo
      @repo ||= upstream_repo || origin_repo
    end

    def upstream_repo
      unless @upstream_repo
        if r = git('config remote.upstream.url')
          @upstream_repo = r[/\:(.+)\.git$/, 1]
        else
          nil
        end
      end
      @upstream_repo
    end

    def origin_repo
      unless @origin_repo
        unless r = git('config remote.origin.url')
          raise Error, "Can't find remote 'origin'"
        end
        @origin_repo = r[/\:(.+)\.git$/, 1]
      end
      @origin_repo
    end

    def origin_user
      origin_repo[/(.+)\/.+/, 1]
    end

    def upstream_user
      upstream_repo[/(.+)\/.+/, 1] if upstream_repo
    end

    def print_issue(issue, prefix_msg)
      puts "#{prefix_msg}: ##{issue.number} - #{issue.title}"
    end

    def git(cmd)
      result = `git #{cmd}`.strip
      if result.length == 0
        false
      else
        result
      end
    end

  end
end
