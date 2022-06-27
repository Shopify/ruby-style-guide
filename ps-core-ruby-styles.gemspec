# frozen_string_literal: true

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "ps-core-ruby-styles"
  s.version     = "0.0.1"
  s.summary     = "PsCore's style guide for Ruby."
  s.description = "Gem containing the rubocop.yml config that corresponds to "\
    "the implementation of the PsCore style guide for Ruby."

  s.license = "MIT"

  s.author   = "PsCore"
  s.homepage = "https://github.com/technekes/ps-core-ruby-styles"

  s.files = ["rubocop.yml", "rubocop-cli.yml"]

  s.metadata = {
    "source_code_uri" => "https://github.com/technekes/ps-core-ruby-styles/tree/v#{s.version}",
    "allowed_push_host" => 'https://gemfury.com'
  }

  s.required_ruby_version = ">= 3.1.1"

  s.add_dependency("rubocop", "~> 1.30")
end
