# frozen_string_literal: true

require "test_helper"
require "rubocop/minitest/assert_offense"

module RuboCop
  module Cop
    module Lint
      class ProcCaseWhenTest < ::Minitest::Test
        include ::RuboCop::Minitest::AssertOffense

        MESSAGE = "Avoid a `case`/`when` where every `when` is a proc or value " \
          "literal: each proc literal allocates a new `Proc` every time the " \
          "`case` is evaluated and adds `Proc#call` overhead, and the whole " \
          "thing is just a harder-to-read `if`/`elsif` tree. Use `if`/`elsif` " \
          "instead."

        def setup
          @cop = ProcCaseWhen.new
        end

        def test_every_when_is_a_lambda_literal_is_an_offense
          assert_offense(<<~RUBY)
            case value
            ^^^^^^^^^^ Lint/ProcCaseWhen: #{MESSAGE}
            when ->(x) { x > 10 } then :big
            when ->(x) { x < 0 } then :negative
            else
              :other
            end
          RUBY
        end

        def test_lambda_proc_and_proc_new_are_offenses
          assert_offense(<<~RUBY)
            case value
            ^^^^^^^^^^ Lint/ProcCaseWhen: #{MESSAGE}
            when lambda { |x| x > 10 } then :big
            when proc { |x| x < 0 } then :negative
            when Proc.new { |x| x.nil? } then :nil
            end
          RUBY
        end

        def test_numbered_parameter_procs_are_offenses
          assert_offense(<<~RUBY)
            case value
            ^^^^^^^^^^ Lint/ProcCaseWhen: #{MESSAGE}
            when proc { _1 > 10 } then :big
            end
          RUBY
        end

        def test_single_when_listing_multiple_procs_is_an_offense
          assert_offense(<<~RUBY)
            case value
            ^^^^^^^^^^ Lint/ProcCaseWhen: #{MESSAGE}
            when ->(x) { x > 10 }, ->(x) { x < 0 } then :extreme
            end
          RUBY
        end

        def test_procs_mixed_with_value_literals_are_offenses
          assert_offense(<<~RUBY)
            case value
            ^^^^^^^^^^ Lint/ProcCaseWhen: #{MESSAGE}
            when 0 then :zero
            when "big", :huge then :large
            when ->(x) { x > 10 } then :big
            end
          RUBY
        end

        def test_single_when_mixing_proc_and_value_literal_is_an_offense
          assert_offense(<<~RUBY)
            case value
            ^^^^^^^^^^ Lint/ProcCaseWhen: #{MESSAGE}
            when nil, ->(x) { x > 10 } then :thing
            end
          RUBY
        end

        def test_proc_mixed_with_in_file_value_literal_constant_is_an_offense
          assert_offense(<<~RUBY)
            PERSONAL_AGENT = "personal_agent"
            INTERNAL_SOURCES = ["a"].to_set.freeze

            def bucket_for(source)
              case source
              ^^^^^^^^^^^ Lint/ProcCaseWhen: #{MESSAGE}
              when PERSONAL_AGENT then :personal
              when ->(s) { INTERNAL_SOURCES.include?(s) } then :internal
              else :other
              end
            end
          RUBY
        end

        def test_proc_stored_in_in_file_constant_is_an_offense
          assert_offense(<<~RUBY)
            MATCHER = ->(s) { s.positive? }
            case value
            ^^^^^^^^^^ Lint/ProcCaseWhen: #{MESSAGE}
            when MATCHER then :m
            when 0 then :zero
            end
          RUBY
        end

        def test_proc_mixed_with_unresolvable_cross_file_constant_is_not_an_offense
          assert_no_offenses(<<~RUBY)
            case value
            when EXTERNAL_CONST then :x
            when ->(x) { x > 10 } then :big
            end
          RUBY
        end

        def test_proc_mixed_with_in_file_range_constant_is_not_an_offense
          assert_no_offenses(<<~RUBY)
            RANGE = 1..10
            case value
            when RANGE then :small
            when ->(x) { x > 100 } then :big
            end
          RUBY
        end

        def test_proc_mixed_with_class_pattern_is_not_an_offense
          assert_no_offenses(<<~RUBY)
            case value
            when Integer then :int
            when ->(x) { x > 10 } then :big
            end
          RUBY
        end

        def test_proc_mixed_with_range_pattern_is_not_an_offense
          assert_no_offenses(<<~RUBY)
            case value
            when 1..10 then :small
            when ->(x) { x > 100 } then :big
            end
          RUBY
        end

        def test_proc_mixed_with_regexp_pattern_is_not_an_offense
          assert_no_offenses(<<~RUBY)
            case value
            when /\\Aadmin/ then :admin
            when ->(x) { x.empty? } then :blank
            end
          RUBY
        end

        def test_single_when_mixing_proc_and_class_pattern_is_not_an_offense
          assert_no_offenses(<<~RUBY)
            case value
            when Integer, ->(x) { x > 10 } then :thing
            end
          RUBY
        end

        def test_case_without_any_procs_is_not_an_offense
          assert_no_offenses(<<~RUBY)
            case value
            when Integer then :int
            when 1..10 then :small
            when 42 then :answer
            end
          RUBY
        end

        def test_case_of_only_value_literals_is_not_an_offense
          assert_no_offenses(<<~RUBY)
            case value
            when 0 then :zero
            when 1 then :one
            end
          RUBY
        end

        def test_case_without_a_subject_is_not_an_offense
          assert_no_offenses(<<~RUBY)
            case
            when ->(x) { x > 10 } then :big
            end
          RUBY
        end

        def test_case_in_pattern_matching_is_not_an_offense
          # `case`/`in` builds a `case_match` node, not a `case` node, so this
          # cop (which only hooks `on_case`) must not fire even though a proc
          # pattern is a valid value pattern that matches via `===`.
          assert_no_offenses(<<~RUBY)
            case value
            in ->(x) { x > 10 } then :big
            in ->(x) { x < 0 } then :negative
            end
          RUBY
        end

        def test_non_proc_literal_block_is_not_an_offense
          assert_no_offenses(<<~RUBY)
            case value
            when build_matcher { |x| x > 10 } then :big
            end
          RUBY
        end
      end
    end
  end
end
