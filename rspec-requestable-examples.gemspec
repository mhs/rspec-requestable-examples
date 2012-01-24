# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "rspec/requestable-examples/version"

Gem::Specification.new do |s|
  s.name             = 'rspec-requestable-examples'
  s.version          = RSpec::RequestableExamples::Version::STRING
  s.platform         = Gem::Platform::RUBY
  s.license          = "MIT"
  s.summary          = "rspec-requestable-examples-#{RSpec::RequestableExamples::Version::STRING}"
  s.description      = "Let's you include specific examples from shared example sets."
  s.authors          = ["Zach Dennis"]
  s.email            = 'zach.dennis@gmail.com'
  s.files            = ["lib/rspec/requestable-examples.rb"]
  s.homepage         = 'http://github.com/mhs/rspec-requestable-examples'
                     
  s.files            = `git ls-files -- lib/*`.split("\n")
  s.files            += %w[README.markdown License.txt]
  s.test_files       = `git ls-files -- {spec,features}/*`.split("\n")
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"

  s.add_development_dependency "rake",     "~> 0.9.2"
  s.add_development_dependency "cucumber", "~> 1.1.0"
  s.add_development_dependency "aruba",    "~> 0.4.11"
  s.add_development_dependency "fakefs",   "0.4.0"
  s.add_development_dependency "syntax",   "1.0.0"
end
