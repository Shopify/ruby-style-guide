# frozen_string_literal: true

require 'test_helper'
require 'pry'
require 'yaml'

class RubyVersionsTest < Minitest::Test
  def test_ci_matrix_includes_minimum_ruby_version
    minimum_ruby_version = normalize(extract_minimum_ruby_version_from_gemspec)
    ruby_versions = extract_ruby_versions_from_ci_matrix.map { |version| normalize(version) }

    assert_includes(
      ruby_versions,
      minimum_ruby_version,
      "CI must be configured to test as far back as gem's required_ruby_version",
    )
  end

  private

  def extract_minimum_ruby_version_from_gemspec
    # This naively extracts the minimum Ruby version compatible with out gemspec
    # allowing us to ensure that it is included in the CI matrix.
    minimum_ruby_version = File.read('rubocop-shopify.gemspec')[/(?<=required_ruby_version = ['"]>= ).*(?=['"]$)/]

    return minimum_ruby_version unless minimum_ruby_version.nil?

    flunk('Failed to extract required_ruby_version from gemspec')
  end

  def extract_ruby_versions_from_ci_matrix
    YAML
      .load_file('.github/workflows/ruby.yml')
      .fetch('jobs')
      .fetch('build')
      .fetch('strategy')
      .fetch('matrix')
      .fetch('ruby')
  end

  # Remove the trailing .0 for versions of the form X.Y.0
  # Otherwise, return the version unchanged
  def normalize(version)
    if version.match?(/^\d+\.\d+\.0$/)
      version.chomp('.0')
    else
      version
    end
  end
end
