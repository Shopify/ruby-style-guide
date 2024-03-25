# frozen_string_literal: true

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "rubocop-shopify"
  s.version     = "2.15.1"
  s.summary     = "Shopify's style guide for Ruby."
  s.description = "Gem containing the rubocop.yml config that corresponds to " \
    "the implementation of the Shopify's style guide for Ruby."

  s.license = "MIT"

  s.author   = "Shopify Engineering"
  s.email    = "gems@shopify.com"
  s.homepage = "https://shopify.github.io/ruby-style-guide/"

  s.files = Dir["rubocop*.yml", "lib/**/*", "LICENSE.md", "README.md"]

  s.metadata = {
    "source_code_uri" => "https://github.com/Shopify/ruby-style-guide/tree/v#{s.version}",
    "allowed_push_host" => "https://rubygems.org",
  }

  s.required_ruby_version = ">= 3.0.0"

  s.add_dependency("rubocop", "~> 1.51")
end
