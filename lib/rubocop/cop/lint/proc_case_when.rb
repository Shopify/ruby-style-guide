# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module Lint
      # Checks for `case` statements whose `when` conditions are only proc/lambda
      # literals and value literals (with at least one proc).
      #
      # Such a `case` is just a harder-to-read `if`/`elsif` tree with a needless
      # performance cost: a `when` clause matches using `pattern === subject`,
      # and for a proc `Proc#===` is an alias for `Proc#call`. Every inline proc
      # literal therefore allocates a brand new `Proc` object each time the
      # `case` is evaluated (on a hot path, once per branch per call) and adds
      # `Proc#call` indirection, where an `if`/`elsif` allocates nothing. For a
      # value literal (number, string, symbol, `nil`, `true`, `false`) `===` is
      # `==`, so the whole statement is exactly equivalent to `if`/`elsif` using
      # `Proc#call` and `==`. Use `if`/`elsif` instead.
      #
      # Constants assigned a proc literal or a value literal *in the same file*
      # are resolved and treated as such. Constants defined in other files cannot
      # be resolved: a bare `when SOME_CONST` is indistinguishable from matching
      # against a class, so those are left alone to avoid flagging idiomatic
      # `case obj when SomeClass`.
      #
      # Cases that use class, range, or regexp patterns are also left alone:
      # those rely on `===` in ways that read far worse as `if` conditions
      # (`is_a?`, `cover?`, `match?`), which is exactly what `case` is for.
      #
      # @example
      #
      #   # bad - every `when` is a proc (a new proc is allocated on each call)
      #   case value
      #   when ->(x) { x > 10 } then :big
      #   when ->(x) { x < 0 }  then :negative
      #   else :other
      #   end
      #
      #   # bad - only procs and value literals (including value-literal constants)
      #   NAME = "widget"
      #   case value
      #   when NAME             then :named
      #   when ->(x) { x > 10 } then :big
      #   end
      #
      #   # good - no proc allocation, and easier to read
      #   if value > 10
      #     :big
      #   elsif value < 0
      #     :negative
      #   else
      #     :other
      #   end
      #
      #   # good - a class/range/regexp pattern makes `case` the clearer choice,
      #   # even alongside a proc.
      #   case value
      #   when Integer          then :int
      #   when ->(x) { x > 10 } then :big
      #   end
      class ProcCaseWhen < ::RuboCop::Cop::Base
        MSG = "Avoid a `case`/`when` where every `when` is a proc or value " \
          "literal: each proc literal allocates a new `Proc` every time the " \
          "`case` is evaluated and adds `Proc#call` overhead, and the whole " \
          "thing is just a harder-to-read `if`/`elsif` tree. Use `if`/`elsif` " \
          "instead."

        # Matches `->(x) {}`, `lambda {}`, `proc {}` and `Proc.new {}`, including
        # their numbered-parameter (`_1`) block variants.
        # @!method proc_literal?(node)
        def_node_matcher :proc_literal?, <<~PATTERN
          {
            ({block numblock} (send nil? {:lambda :proc}) ...)
            ({block numblock} (send (const {nil? cbase} :Proc) :new) ...)
          }
        PATTERN

        def on_new_investigation
          super
          @constant_kinds = collect_constant_kinds
        end

        def on_case(node)
          # `case` without a subject evaluates each `when` for truthiness rather
          # than with `===`, so procs there are not used as matchers.
          return unless node.condition

          kinds = node.when_branches.flat_map(&:conditions).map { |condition| kind_of(condition) }
          # Require at least one proc; a case of only value literals is a fine
          # dispatch and out of scope here.
          return unless kinds.include?(:proc)
          # Bail out if any condition is something other than a proc or a value
          # literal (e.g. a class, range, regexp, or an unresolvable constant),
          # where `case` reads better than the equivalent `if`.
          return unless kinds.all? { |kind| kind == :proc || kind == :value }

          add_offense(node)
        end

        private

        # Classifies a `when` condition (or a constant's assigned value) as a
        # proc, a value literal, or `:other` (anything we should not rewrite).
        def kind_of(node)
          # Unwrap a trailing `.freeze` so `FOO = "bar".freeze` counts as a value.
          node = node.receiver if node.send_type? && node.method?(:freeze) && node.receiver

          if proc_literal?(node)
            :proc
          elsif node.basic_literal?
            :value
          elsif node.const_type?
            # `@constant_kinds` is still nil while being built; an unresolved
            # constant is treated as `:other` (conservative).
            (@constant_kinds || {}).fetch(node.short_name, :other)
          else
            :other
          end
        end

        # Maps the short (demodulized) name of every constant assigned in this
        # file to its kind, so bare `when CONST` references can be resolved.
        def collect_constant_kinds
          kinds = {}
          ast = processed_source.ast
          return kinds unless ast

          ast.each_node(:casgn) do |casgn|
            value = casgn.children[2]
            next unless value

            kinds[casgn.name] = kind_of(value)
          end
          kinds
        end
      end
    end
  end
end
