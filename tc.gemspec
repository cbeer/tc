# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tc/version"

Gem::Specification.new do |s|
  s.name        = "tc"
  s.version     = Tc::VERSION
  s.authors     = ["Chris Beer"]
  s.email       = ["chris_beer@wgbh.org"]
  s.homepage    = ""
  s.summary     = %q{Timecode parsing}
  s.description = %q{Timecode parsing}

  s.rubyforge_project = "tc"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "parslet"
end
