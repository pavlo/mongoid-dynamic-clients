# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "mongoid/dynamic_clients/version"

Gem::Specification.new do |spec|
  spec.name          = "mongoid-dynamic_clients"
  spec.version       = Mongoid::DynamicClients::VERSION
  spec.authors       = ["pavlo"]
  spec.email         = ["pavlikus@gmail.com"]

  spec.summary       = %q{Helps MongoId enabled apps to talk to multiple MongoDB databases}
  spec.description   = %q{The gem makes it easier to switch databases at runtime without the need to configure them all in `mongoid.yml` file. This is helpful when you do not know the databases you're connecting to at the build time, say you're developing a multi-tenancy or a white-labeable application where every tenant has its own database and you do not have the ability to enumerate them all in `mongoid.yml`}
  spec.homepage      = "https://github.com/pavlo/mongoid-dynamic-clients"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency("mongoid", ["~> 6"])

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
