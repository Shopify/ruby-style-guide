# frozen_string_literal: true

require "test_helper"
require "diffy"
require "rubocop"
require "rake"

class ConfigTest < Minitest::Test
  def test_config_is_unchanged
    skip if checking_rubocop_version_compatibility?

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
    skip if checking_rubocop_version_compatibility?

    config = RuboCop::ConfigLoader.load_file("rubocop.yml")
    default_config = RuboCop::ConfigLoader.default_configuration
    redundant_config = Hash.new { |hash, key| hash[key] = {} }

    # This entry is not a cop.
    config.delete("inherit_mode")

    config.each do |cop_name, cop_config|
      default_cop_config = default_config.fetch(cop_name)
      cop_config.each do |key, value|
        default_value = default_cop_config[key]
        redundant_config[cop_name][key] = value if value == default_value
      end
    end

    error_message = <<~ERROR
      Error: The following config values are the same as the default Rubocop configuration:

      #{redundant_config.to_yaml.delete_prefix("---\n")}

      Please remove these entries from the configuration, as they are unnecessary.
    ERROR

    assert(redundant_config.empty?, error_message)
  end

  def test_config_is_sorted_alphabetically
    config_keys = RuboCop::ConfigLoader.load_file("rubocop.yml").to_hash.keys
    all_cops_index = config_keys.index("AllCops")
    following_keys = config_keys[(all_cops_index + 1)..-1]

    assert_sorted(following_keys, "Keys after AllCops in rubocop.yml must be sorted")
  end

  private

  def checking_rubocop_version_compatibility?
    ENV.fetch("CHECKING_RUBOCOP_VERSION_COMPATIBILITY", "") == "true"
  end

  def assert_sorted(actual, message)
    expected_string = actual.sort.join("\n")
    actual_string = actual.join("\n")

    assert_equal(expected_string, actual_string, message)
  end
end
