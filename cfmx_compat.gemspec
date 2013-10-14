# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cfmx_compat/version'

Gem::Specification.new do |spec|
  spec.name          = "cfmx_compat"
  spec.version       = CfmxCompat::Version
  spec.authors       = ["Jason Lambert"]
  spec.email         = ["jlambert@globalpersonals.co.uk"]
  spec.description   = %q{A Ruby encryption library compatible with the CFMX_COMPAT standard used in ColdFusion}
  spec.summary       = %q{A Ruby encryption library compatible with the CFMX_COMPAT standard used in ColdFusion}
  spec.homepage      = "https://github.com/globaldev/cfmx_compat"
  spec.license       = "LGPL"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
