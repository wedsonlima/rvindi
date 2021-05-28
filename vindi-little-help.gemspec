# frozen_string_literal: true

require_relative "lib/vindi/version"

Gem::Specification.new do |spec|
  spec.name          = "vindi-little-help"
  spec.version       = Vindi::VERSION
  spec.authors       = ["Wedson Lima"]
  spec.email         = ["wedson.sousa.lima@gmail.com"]

  spec.summary       = "Vindi API - With a little help from my friends"
  spec.description   = "A little help to work with Vindi payments API in your RoR projects."
  spec.homepage      = "https://github.com/wedsonlima/vindi"
  spec.license       = "MIT"

  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 1.4"
  spec.add_dependency "faraday_middleware", "~> 1.0"
  spec.add_dependency "her", "~> 1.1"

  spec.add_development_dependency "httplog"
  spec.add_development_dependency "rspec", "~> 3.2"
end
