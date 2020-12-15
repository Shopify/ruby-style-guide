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

  def test_config_loka
    require "hash_diff"

    full_config_text = File.read("test/fixtures/full_config.yml")

    config = RuboCop::ConfigLoader.load_file("rubocop2.yml")
    config_hash = RuboCop::ConfigLoader.merge_with_default(config, "rubocop2.yml").to_h
    config_text = config_hash.to_yaml.gsub(config.base_dir_for_path_parameters, "")

    diff = Diffy::Diff.new(full_config_text, config_text, context: 5).to_s

    unless diff.empty?
      puts "Changes detected"


      original_config = RuboCop::ConfigLoader.load_file("rubocop.yml")
      original_config_hash = RuboCop::ConfigLoader.merge_with_default(original_config, "rubocop.yml").to_h

      new_config_hash = HashDiff::Comparison.new(config_hash, original_config_hash).left_diff
      new_config_hash.fetch("AllCops").delete("Enabled")
      new_config_hash.fetch("AllCops").delete("DisabledByDefault")
      new_config_hash.delete("Lint/Syntax")

      new_config_text = new_config_hash.to_yaml
        .gsub(config.base_dir_for_path_parameters, "")
        .gsub("&1 !ruby/class 'HashDiff::NO_VALUE'", "")
        .gsub("*1", "")

      File.write("rubocop3.yml", new_config_text)

      new_full_config = RuboCop::ConfigLoader.load_file("rubocop3.yml")
      new_full_config = RuboCop::ConfigLoader.merge_with_default(new_full_config, "rubocop3.yml")
      new_full_config_text = new_full_config.to_h.to_yaml.gsub(config.base_dir_for_path_parameters, "")

      diff = Diffy::Diff.new(full_config_text, new_full_config_text, context: 5).to_s
    end

    assert(diff.empty?, diff)
  end
end
