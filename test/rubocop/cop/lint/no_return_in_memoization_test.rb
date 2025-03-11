# frozen_string_literal: true

require "test_helper"
require "rubocop/minitest/assert_offense"

module RuboCop
  module Cop
    module Lint
      class NoReturnInMemoizationTest < ::Minitest::Test
        include ::RuboCop::Minitest::AssertOffense

        def setup
          @cop = NoReturnInMemoization.new
        end

        def test_returns_in_memoization_are_offenses
          assert_offense(<<~RUBY)
            def foo
              @foo ||= begin
                return 1 if bar
                ^^^^^^^^ Lint/NoReturnInMemoization: Do not `return` in `begin..end` blocks in instance variable assignment contexts.
                2
              end
            end
          RUBY
        end

        def test_returns_in_regular_assignment_are_not_offenses
          assert_no_offenses(<<~RUBY)
            def foo
              foo = begin
                return 1 if bar
                2
              end
            end
          RUBY
        end

        def test_returns_in_regular_assignment_for_instance_variable_are_offenses
          assert_offense(<<~RUBY)
            def foo
              @foo = begin
                return 1 if bar
                ^^^^^^^^ Lint/NoReturnInMemoization: Do not `return` in `begin..end` blocks in instance variable assignment contexts.
                2
              end
            end
          RUBY
        end

        def test_returns_in_operation_assignment_for_instance_variable_are_offenses
          assert_offense(<<~RUBY)
            def foo
              @foo += begin
                return 1 if bar
                ^^^^^^^^ Lint/NoReturnInMemoization: Do not `return` in `begin..end` blocks in instance variable assignment contexts.
                2
              end
            end
          RUBY

          assert_offense(<<~RUBY)
            def foo
              @foo -= begin
                return 1 if bar
                ^^^^^^^^ Lint/NoReturnInMemoization: Do not `return` in `begin..end` blocks in instance variable assignment contexts.
                2
              end
            end
          RUBY

          assert_offense(<<~RUBY)
            def foo
              @foo *= begin
                return 1 if bar
                ^^^^^^^^ Lint/NoReturnInMemoization: Do not `return` in `begin..end` blocks in instance variable assignment contexts.
                2
              end
            end
          RUBY

          assert_offense(<<~RUBY)
            def foo
              @foo /= begin
                return 1 if bar
                ^^^^^^^^ Lint/NoReturnInMemoization: Do not `return` in `begin..end` blocks in instance variable assignment contexts.
                2
              end
            end
          RUBY

          assert_offense(<<~RUBY)
            def foo
              @foo **= begin
                return 1 if bar
                ^^^^^^^^ Lint/NoReturnInMemoization: Do not `return` in `begin..end` blocks in instance variable assignment contexts.
                2
              end
            end
          RUBY

          assert_offense(<<~RUBY)
            def foo
              @foo &&= begin
                return 1 if bar
                ^^^^^^^^ Lint/NoReturnInMemoization: Do not `return` in `begin..end` blocks in instance variable assignment contexts.
                2
              end
            end
          RUBY
        end

        def test_returns_in_operation_assignment_for_instance_variable_are_not_offenses
          assert_no_offenses(<<~RUBY)
            def foo
              foo += begin
                return 1 if bar
                2
              end
            end
          RUBY

          assert_no_offenses(<<~RUBY)
            def foo
              foo -= begin
                return 1 if bar
                2
              end
            end
          RUBY

          assert_no_offenses(<<~RUBY)
            def foo
              foo *= begin
                return 1 if bar
                2
              end
            end
          RUBY

          assert_no_offenses(<<~RUBY)
            def foo
              foo /= begin
                return 1 if bar
                2
              end
            end
          RUBY

          assert_no_offenses(<<~RUBY)
            def foo
              foo **= begin
                return 1 if bar
                2
              end
            end
          RUBY
        end

        def test_returns_in_assignment_for_exception_handling_are_not_offenses
          assert_no_offenses(<<~RUBY)
            def foo
              foo += begin
                bar
              rescue
                return 2 if baz
              end
            end
          RUBY
        end

        def test_returns_in_memoization_rescue_blocks_are_offenses
          assert_offense(<<~RUBY)
            def foo
              @foo ||= begin
                bar
              rescue
                return 2 if baz
                ^^^^^^^^ Lint/NoReturnInMemoization: Do not `return` in `begin..end` blocks in instance variable assignment contexts.
              end
            end
          RUBY
        end
      end
    end
  end
end
