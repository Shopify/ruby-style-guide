# frozen_string_literal: true

require "test_helper"
require "rubocop/minitest/assert_offense"
require "rubocop/cop/lint/no_disable_comment"

module RuboCop
  module Cop
    module Lint
      class NoDisableCommentTest < ::Minitest::Test
        include ::RuboCop::Minitest::AssertOffense

        def setup
          @cop = NoDisableComment.new
        end

        def test_disable_comment_without_allowed_cops_is_offense
          assert_offense(<<~RUBY)
            def foo
              bar # rubocop:disable Style/StringLiterals
                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Lint/NoDisableComment: Avoid disabling RuboCop rule `Style/StringLiterals`.
            end
          RUBY
        end

        def test_disable_comment_with_multiple_cops_is_offense
          assert_offense(<<~RUBY)
            def foo
              # rubocop:disable Style/StringLiterals, Layout/LineLength
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Lint/NoDisableComment: Avoid disabling RuboCop rule `Style/StringLiterals, Layout/LineLength`.
              bar
            end
          RUBY
        end

        def test_disable_comment_for_allowed_cop_is_not_offense
          config = { 'AllowedCops' => ['Style/StringLiterals'] }
          @cop = NoDisableComment.new(RuboCop::Config.new('Lint/NoDisableComment' => config))

          assert_no_offenses(<<~RUBY)
            def foo
              bar # rubocop:disable Style/StringLiterals
            end
          RUBY
        end

        def test_disable_comment_mixed_allowed_and_disallowed_cops_is_offense
          config = { 'AllowedCops' => ['Style/StringLiterals'] }
          @cop = NoDisableComment.new(RuboCop::Config.new('Lint/NoDisableComment' => config))

          assert_offense(<<~RUBY)
            def foo
              # rubocop:disable Style/StringLiterals, Layout/LineLength
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid disabling RuboCop rule `Layout/LineLength`.
              bar
            end
          RUBY
        end

        def test_disable_comment_all_allowed_cops_is_not_offense
          config = { 'AllowedCops' => ['Style/StringLiterals', 'Layout/LineLength'] }
          @cop = NoDisableComment.new(RuboCop::Config.new('Lint/NoDisableComment' => config))

          assert_no_offenses(<<~RUBY)
            def foo
              # rubocop:disable Style/StringLiterals, Layout/LineLength
              bar
            end
          RUBY
        end

        def test_regular_comments_are_not_offenses
          assert_no_offenses(<<~RUBY)
            def foo
              # This is just a regular comment
              bar
            end
          RUBY
        end

        def test_rubocop_enable_comments_are_not_offenses
          assert_no_offenses(<<~RUBY)
            def foo
              # rubocop:enable Style/StringLiterals
              bar
            end
          RUBY
        end

        def test_disable_comment_with_extra_whitespace_is_offense
          assert_offense(<<~RUBY)
            def foo
              #   rubocop:disable   Style/StringLiterals
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Lint/NoDisableComment: Avoid disabling RuboCop rule `Style/StringLiterals`.
              bar
            end
          RUBY
        end

        def test_inline_disable_comment_is_offense
          assert_offense(<<~RUBY)
            def foo
              some_long_method_call # rubocop:disable Layout/LineLength
                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Lint/NoDisableComment: Avoid disabling RuboCop rule `Layout/LineLength`.
            end
          RUBY
        end

        def test_disable_all_cops_is_offense
          assert_offense(<<~RUBY)
            def foo
              # rubocop:disable all
              ^^^^^^^^^^^^^^^^^^^^^ Lint/NoDisableComment: Avoid disabling RuboCop rules.
              bar
            end
          RUBY
        end

        def test_empty_disable_comment_is_not_offense
          assert_no_offenses(<<~RUBY)
            def foo
              # rubocop:disable
              bar
            end
          RUBY
        end

        def test_todo_comment_without_allowed_cops_is_offense
          assert_offense(<<~RUBY)
            def foo
              # rubocop:todo Style/StringLiterals
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Lint/NoDisableComment: Avoid disabling RuboCop rule `Style/StringLiterals`.
              bar
            end
          RUBY
        end

        def test_todo_comment_with_multiple_cops_is_offense
          assert_offense(<<~RUBY)
            def foo
              # rubocop:todo Style/StringLiterals, Layout/LineLength
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Lint/NoDisableComment: Avoid disabling RuboCop rule `Style/StringLiterals, Layout/LineLength`.
              bar
            end
          RUBY
        end

        def test_todo_comment_for_allowed_cop_is_not_offense
          config = { 'AllowedCops' => ['Style/StringLiterals'] }
          @cop = NoDisableComment.new(RuboCop::Config.new('Lint/NoDisableComment' => config))

          assert_no_offenses(<<~RUBY)
            def foo
              # rubocop:todo Style/StringLiterals
              bar
            end
          RUBY
        end

        def test_todo_comment_mixed_allowed_and_disallowed_cops_is_offense
          config = { 'AllowedCops' => ['Style/StringLiterals'] }
          @cop = NoDisableComment.new(RuboCop::Config.new('Lint/NoDisableComment' => config))

          assert_offense(<<~RUBY)
            def foo
              # rubocop:todo Style/StringLiterals, Layout/LineLength
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Avoid disabling RuboCop rule `Layout/LineLength`.
              bar
            end
          RUBY
        end

        def test_inline_todo_comment_is_offense
          assert_offense(<<~RUBY)
            def foo
              some_long_method_call # rubocop:todo Layout/LineLength
                                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Lint/NoDisableComment: Avoid disabling RuboCop rule `Layout/LineLength`.
            end
          RUBY
        end

        def test_empty_todo_comment_is_not_offense
          assert_no_offenses(<<~RUBY)
            def foo
              # rubocop:todo
              bar
            end
          RUBY
        end
      end
    end
  end
end
