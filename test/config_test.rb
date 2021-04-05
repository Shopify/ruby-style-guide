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

      assert(diff.empty?, diff)
    end
  end
end
