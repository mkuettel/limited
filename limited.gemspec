# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'limited/version'

Gem::Specification.new do |spec|
  spec.name          = "limited"
  spec.version       = Limited::VERSION
  spec.authors       = ["Moritz Küttel"]
  spec.email         = ["moritz.kuettel@gmail.com"]
  spec.description   = %q{helps you limiting certain actions to prevent spam/dos}
  spec.summary       = %q{
    Some utility functions to help you limit some actions in your applications
    (like logins, contact forms, posting of comments, etc.) to stop spammers
    to absue your services.}

  spec.homepage      = "https://github.com/mkuettel/limited"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "debugger"
end
