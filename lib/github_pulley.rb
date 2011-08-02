require "optitron"
require "octokit"
require "github_pulley/base"
require "github_pulley/version"
require "github_pulley/exception"

module GithubPulley
  class << self
    # Alias for GithubPulley::Base.new
    def new
      GithubPulley::Base.new
    end

    def method_missing(method, *args, &block)
      return super unless new.respond_to?(method)
      new.send(method, *args, &block)
    end

    def respond_to?(method, include_private=false)
      new.respond_to?(method, include_private) || super(method, include_private)
    end
  end
end

