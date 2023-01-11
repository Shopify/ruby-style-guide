# frozen_string_literal: true

require "test_helper"
require "tempfile"

# These ensure we have rules configured to behave as expected, especially for tricky cases such as indentation.
class IntegrationTest < Minitest::Test
  def test_indentation
    assert_autocorrects(<<~'DIFF')
       # typed: true
       # frozen_string_literal: true

       sig { params(a: Something, b: SomethingElse).void }
       def some_method(a, b)
         unless b.something
           b.something_else
      -    Constant.call(ANOTHER_CONSTANT,
      -      (T.must(b.another_thing) - b.some_time.to_i) * 1000.0)
      +    Constant.call(
      +      ANOTHER_CONSTANT,
      +      (T.must(b.another_thing) - b.some_time.to_i) * 1000.0,
      +    )
         end
       end
    DIFF
  end

  def test_indentation2
    assert_autocorrects(<<~'DIFF')
       # typed: true
       # frozen_string_literal: true

       class ExampleController < ApplicationController
         sig { void }
         def create
           @object = something
           @object.action

      -    redirect_to(a_path(@object.to_route_params),
      -      notice: "success")
      +    redirect_to(
      +      a_path(@object.to_route_params),
      +      notice: "success",
      +    )
         rescue SomeError
      -    redirect_to(a_path(@object.to_route_params),
      -      alert: "failure")
      +    redirect_to(
      +      a_path(@object.to_route_params),
      +      alert: "failure",
      +    )
         end
       end
    DIFF
  end

  private

  def assert_autocorrects(diff)
    initial, expected = split_diff(diff)
    normalized_path = "file.rb"
    Tempfile.create(normalized_path) do |file|
      File.write(file.path, initial)
      output, status = run_rubocop_on(file.path, normalized_path:)
      actual = File.read(file.path)

      assert(status.success?, "Rubocop test did not exit cleanly!\n#{output}")
      assert_equal(expected, actual, "Autocorrection did not produce the expected output!\n#{output}")
    end
  end

  def run_rubocop_on(path, normalized_path: path)
    output, status = Open3.capture2e(
      "bundle", "exec", "rubocop",
      "-A",
      "--config", File.join(__dir__, "fixtures/rubocop.integration.yml"),
      path,
    )
    output.gsub!(path, normalized_path) unless path == normalized_path
    [output, status]
  end

  # Splits a naive full file diff into the contents before and the contents after,
  # dropping the diff prefixes (" ", "+", or "-").
  def split_diff(diff)
    before = diff.each_line.reject { |line| line.start_with?("+") }.map { |line| line.sub(/^[ -]/,  '') }.join
    after  = diff.each_line.reject { |line| line.start_with?("-") }.map { |line| line.sub(/^[ \+]/, '') }.join
    [before, after]
  end
end
