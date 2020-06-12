require_relative 'lib/trestle/auth/version'

Gem::Specification.new do |spec|
  spec.name          = "trestle-auth"
  spec.version       = Trestle::Auth::VERSION
  spec.authors       = ["Sam Pohlenz"]
  spec.email         = ["sam@sampohlenz.com"]

  spec.summary       = "Authentication plugin for the Trestle admin framework"
  spec.homepage      = "https://www.trestle.io"
  spec.license       = "LGPL-3.0"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  end

  spec.require_paths = ["lib"]

  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/TrestleAdmin/trestle-auth"

  spec.add_dependency "trestle", "~> 0.9.0", ">= 0.9.3"
  spec.add_dependency "bcrypt",  "~> 3.1.7"

  spec.add_development_dependency "rspec-rails",         "~> 3.0"
  spec.add_development_dependency "show_me_the_cookies", "~> 5.0"
  spec.add_development_dependency "timecop",             "~> 0.9.1"
end
