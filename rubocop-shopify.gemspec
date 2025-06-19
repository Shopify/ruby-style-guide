# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "rubocop/shopify/version"

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "rubocop-shopify"
  s.version     = RuboCop::Shopify::VERSION
  s.summary     = "Shopify's style guide for Ruby."
  s.description = "Gem containing the rubocop.yml config that corresponds to " \
    "the implementation of the Shopify's style guide for Ruby."

  s.license = "MIT"

  s.author   = "Shopify Engineering"
  s.email    = "gems@shopify.com"
  s.homepage = "https://shopify.github.io/ruby-style-guide/"

  s.files = Dir["rubocop*.yml", "lib/**/*", "LICENSE.md", "config/default.yml", "README.md"]

  s.metadata = {
    "source_code_uri" => "https://github.com/Shopify/ruby-style-guide/tree/v#{s.version}",
    "allowed_push_host" => "https://rubygems.org",
    "default_lint_roller_plugin" => "RuboCop::Shopify::Plugin"
  }

  s.required_ruby_version = ">= 3.2.0"

  s.add_dependency("rubocop", "~> 1.72", ">= 1.72.1")
  s.add_dependency("lint_roller")
end
