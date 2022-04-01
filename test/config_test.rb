# frozen_string_literal: true

require "test_helper"
require "diffy"
require "rubocop"
require "rake"

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

  def test_config_has_no_redundant_entries
    config = RuboCop::ConfigLoader.load_file("rubocop.yml")
    default_config = RuboCop::ConfigLoader.default_configuration

    # This entry is not a cop.
    config.delete("inherit_mode")

    config.each do |cop_name, cop_config|
      default_cop_config = default_config.fetch(cop_name)
      cop_config.each do |key, value|
        error_message = <<~ERROR
          Error: #{cop_name} was configured with the same value as the default
          RuboCop configuration.

          #{cop_name}:
            #{key}: #{value}

          Please remove the configuration as it is unnecessary.
        ERROR

        refute_equal(default_cop_config[key], value, error_message)
      end
    end
  end
end
