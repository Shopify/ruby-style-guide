# frozen_string_literal: true

require "rubocop"

namespace :config do
  full_configs_directory = "test/fixtures/full_configs"
  dump_configs = Dir.glob("rubocop*.yml").map { |file| [File.join(full_configs_directory, file), file] }.to_h

  desc "Create the directory to store the full RuboCop config dumps"
  directory full_configs_directory

  dump_configs.each do |dump_file, config_file|
    desc "Dump the full RuboCop config merging defaults and #{config_file}"
    file dump_file => [full_configs_directory, config_file] do
      system(
        "bin/dump-config",
        "--defaults",
        "merge",
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
