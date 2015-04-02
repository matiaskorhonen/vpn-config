# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vpn/config/version'

Gem::Specification.new do |spec|
  spec.name          = "vpn-config"
  spec.version       = VPN::Config::VERSION
  spec.authors       = ["Matias Korhonen"]
  spec.email         = ["matias@kiskolabs.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = %q{Generate iOS/OS X configuration profiles for VPNs}
  spec.description   = %q{Generate iOS/OS X configuration profiles for Private Internet Access VPNs}
  spec.homepage      = "https://github.com/matiaskorhonen/vpn-config"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "plist"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
