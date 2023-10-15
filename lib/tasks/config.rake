# frozen_string_literal: true

require "rubocop"

namespace :config do
  desc "Dump the full RuboCop config as a YAML file for testing"
  task :dump do
    system(
      "bin/dump-config",
      "--defaults",
      "merge",
      "--config",
      "rubocop.yml",
      "--output",
      "test/fixtures/full_config.yml",
      exception: true,
    )
  end
end
