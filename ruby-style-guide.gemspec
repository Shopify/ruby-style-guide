# coding: utf-8
# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "ruby-style-guide"
  spec.version       = '0.0.1'
  spec.authors       = ["Shawn French"]
  spec.email         = ["shawn.french@shopify.com"]

  spec.summary       = 'Shopify-specific ruby styleguide codified into a RuboCop config'
  spec.homepage      = 'https://github.com/Shopify/ruby-style-guide'
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = ['README.md', 'LICENSE.txt', 'rubocop.yml', 'rubocop-cli.yml']

  spec.add_dependency 'rubocop', '~> 0.53'
  spec.add_development_dependency "bundler", "~> 1.16"
end
