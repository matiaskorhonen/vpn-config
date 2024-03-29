# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vpn/config/version'

Gem::Specification.new do |spec|
  spec.name          = "vpn-config"
  spec.version       = VPN::Config::VERSION
  spec.authors       = ["Matias Korhonen"]
  spec.email         = ["matias@kiskolabs.com"]

  spec.summary       = %q{Generate iOS/OS X configuration profiles for VPNs}
  spec.description   = %q{Generate signed and unsigned iOS/OS X configuration profiles for VPNs}
  spec.homepage      = "https://github.com/matiaskorhonen/vpn-config"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.2.0"

  spec.add_dependency "plist"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "minitest", "~> 5.15"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 0.4"
end
