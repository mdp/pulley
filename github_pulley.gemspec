# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "github_pulley/version"

Gem::Specification.new do |s|
  s.name        = "github_pulley"
  s.version     = GithubPulley::VERSION
  s.authors     = ["Mark Percival"]
  s.email       = ["m@mdp.im"]
  s.homepage    = "https://github.com/mdp/pulley"
  s.summary     = "Work with Github Issues and Pull Requests"
  s.description = %q{We're small and trying to eschew the use of a bigger project tracker}

  s.rubyforge_project = "pulley"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_runtime_dependency 'json'
  s.add_runtime_dependency 'octokit', "= 0.6.4"
end
