# frozen_string_literal: true

require "test_helper"
require "diffy"
require "rubocop"

class ConfigTest < Minitest::Test
  def test_config_is_unchanged
    Rake.application.load_rakefile

    original_config = "test/fixtures/full_config.yml"

    Tempfile.create do |tempfile|
      Rake::Task["config:dump"].invoke(tempfile.path)

      diff = Diffy::Diff.new(
        original_config, tempfile.path, source: "files", context: 5
      ).to_s

      error_message = <<~ERROR
        Error: unexpected RuboCop configuration changes were detected.

        #{diff}

        If these changes are intentional, please update the config dump
        by running `bundle exec rake config:dump`.
      ERROR

      assert(diff.empty?, error_message)
    end
  end
end
