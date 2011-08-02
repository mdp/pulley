require "optitron"
require "octokit"
require "pulley/base"
require "pulley/version"
require "pulley/exception"

module Pulley
  class << self
    # Alias for Pulley::Base.new
    def new
      Pulley::Base.new
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

