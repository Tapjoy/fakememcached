# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'fakememcached/version'
require 'date'

Gem::Specification.new do |s|
  s.name = %q{fakememcached}
  s.version = FakeMemcached::Version::STRING

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.0")
  s.authors = ["Viximo"]
  s.date = Date.today.to_s
  s.description = %q{An in-memory hash implementation of memcached}
  s.email = %q{viximo-eng@viximo.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.homepage = %q{http://viximo.com}
  s.require_paths = ["lib"]
  s.summary = %q{An in-memory hash implementation of memcached}
  s.license = "APACHE"
  
  s.files = Dir[
    "README.rdoc",
    "LICENSE",
    "lib/**/*"
  ]
  
  s.add_development_dependency(%q<rspec>, ["~> 1.3.0"])
end

