# frozen_string_literal: true

require "test_helper"
require "diffy"
require "rubocop"
require "rake"
require "erb"
require "yaml"

class ConfigTest < Minitest::Test
  Dir.glob("rubocop*.yml") do |config_path|
    full_config_path = "test/fixtures/full_configs/#{config_path}"

    unless ENV.fetch("CHECKING_RUBOCOP_VERSION_COMPATIBILITY", "") == "true"
      define_method("test_#{config_path}_config_dump_is_unchanged") do
        unless File.exist?(full_config_path)
          flunk "Full config has not been dumped yet. Please run `bundle exec rake config:dump`"
        end

        Tempfile.create do |tempfile|
          tempfile.close # We're not going to write to it here; we just need the path.

          # We dump the config in a clean process, so its default configuration is isolated.
          system(
            "bin/dump-config",
            "--defaults",
            "merge",
            "--config",
            config_path,
            "--output",
            tempfile.path,
            exception: true,
          )

          diff = Diffy::Diff.new(
            full_config_path, tempfile.path, source: "files", context: 5
          ).to_s

          error_message = <<~ERROR
            Error: The full RuboCop configuration based on #{config_path} has changed.

            #{diff}

            If these changes are intentional, please update the config dump
            by running `bundle exec rake config:dump`.
          ERROR

          assert(diff.empty?, error_message)
        end
      end

      define_method("test_#{config_path}_has_no_redundant_entries") do
        config = RuboCop::ConfigLoader.load_file(config_path)
        default_config = Tempfile.create do |tempfile|
          tempfile.close # We're not going to write to it here; we just need the path.

          # We dump the config in a clean process, so its default configuration is isolated.
          system(
            "bin/dump-config",
            "--defaults",
            "only",
            "--config",
            config_path,
            "--output",
            tempfile.path,
            exception: true,
          )

          RuboCop::ConfigLoader.load_file(tempfile.path)
        end

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
          Error: The following config values in #{config_path} are the same as the default Rubocop configuration:

          #{redundant_config.to_yaml.delete_prefix("---\n")}

          Please remove these entries from the configuration, as they are unnecessary.
        ERROR

        assert(redundant_config.empty?, error_message)
      end
    end

    define_method("test_#{config_path}_is_sorted_alphabetically") do
      # We bypass the RuboCop::ConfigLoader, because we want to examine this file only, not any configs it requires.
      # We need to handle ERB ourselves, though, before loading YAML.
      yaml = ERB.new(File.read(config_path)).result
      config_keys = (YAML.respond_to?(:unsafe_load) ? YAML.unsafe_load(yaml) : YAML.load(yaml)).keys

      # Expected order is:
      #   - Keys starting with lowercase, in any order (these are not cop/department config, and order may matter)
      #   - AllCops (optionally)
      #   - Keys starting with uppercase (cop/department config), in alphabetical order

      # Check keys starting with lowercase
      config_keys = config_keys.drop_while { |key| key[0] == key[0].downcase }
      remaining_keys_starting_with_lowercase = config_keys.select { |key| key[0] == key[0].downcase }
      assert(remaining_keys_starting_with_lowercase.empty?, <<~MESSAGE.chomp)
        Keys starting with lowercase in #{config_path} must appear before other keys.
        The following keys were found after keys starting with uppercase:
        #{remaining_keys_starting_with_lowercase.map { |key| "  - #{key}" }.join("\n")}
        Please move them to the top of the file
      MESSAGE

      # Check AllCops
      if (all_cops_index = config_keys.index("AllCops"))
        assert_equal(
          "AllCops",
          config_keys.fetch(all_cops_index),
          "AllCops must appear before other keys starting with uppercase in #{config_path}",
        )
        config_keys.delete_at(all_cops_index)
      end

      # Check remaining keys
      assert_sorted(config_keys, "Keys starting with uppercase in #{config_path} must be sorted alphabetically")
    end

    define_method("test_no_cops_for_#{config_path}_are_configured_as_pending") do
      pending_cops = []

      unless File.exist?(full_config_path)
        flunk "Full config has not been dumped yet. Please run `bundle exec rake config:dump`"
      end

      if YAML.respond_to?(:unsafe_load_file)
        YAML.unsafe_load_file(full_config_path)
      else
        YAML.load_file(full_config_path)
      end.each do |cop_name, cop_config|
        pending_cops << cop_name if Hash === cop_config && cop_config["Enabled"] == "pending"
      end

      assert(pending_cops.empty?, <<~ERROR_MESSAGE.chomp)
        Error: The style guide should take a stance on all cops, but following cops are marked as pending:

        #{pending_cops.map { "    #{_1}:\n      Enabled: pending" }.join("\n\n")}

        Please update #{config_path} to mark all of the these cops as either `Enabled: true` or `Enabled: false`

        If this is a bad time to triage, please open an issue, and mark them as `Enabled: false` for now.
      ERROR_MESSAGE
    end

    define_method("test_#{config_path}_loads") do
      # Simply ensure we're able to load the config without issues, using RuboCop's machinery.
      # For example, detect config for cops that have been added or removed nor working across versions.
      RuboCop::ConfigLoader.load_file(config_path)
      pass
    end
  end

  if ENV.key?("GITHUB_ACTIONS")
    require "psych"

    def test_github_actions_libyaml_version
      assert_operator(Gem::Version.new(Psych::LIBYAML_VERSION), :<, Gem::Version.new("0.2.5"), <<~MSG)
        It looks like GitHub Actions has updated their libyaml version to 0.2.5 or greater,
        so we should remove our patch in `bin/dump-full-config`, and then delete this test.
      MSG
    end
  end

  private

  def assert_sorted(actual, message)
    expected_string = actual.sort.join("\n")
    actual_string = actual.join("\n")

    assert_equal(expected_string, actual_string, message)
  end
end
