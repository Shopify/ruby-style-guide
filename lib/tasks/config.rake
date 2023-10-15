# frozen_string_literal: true

require "rubocop"

namespace :config do
  full_configs_directory = "test/fixtures/full_configs"
  dump_configs = Dir.glob("rubocop*.yml").map { |file| [File.join(full_configs_directory, file), file] }.to_h

  desc "Create the directory to store the full RuboCop config dumps"
  directory full_configs_directory

  dump_configs.each do |dump_file, config_file|
    desc "Dump the full RuboCop config merging defaults and #{config_file}"
    task dump_file => [full_configs_directory, *dump_configs.values] do
      system(
        "bin/dump-config",
        "--defaults",
        # For plugin configs, we want to exclude any unchanged RuboCop core defaults
        # For other configs, we want to merge them with all RuboCop defaults (core, and plugin defaults)
        config_file.start_with?("rubocop.") ? "diff" : "merge",
        "--config",
        config_file,
        "--output",
        dump_file,
        exception: true,
      )
    end
  end

  desc "Dump the full RuboCop configs as a YAML file for testing"
  task dump: dump_configs.keys
end
