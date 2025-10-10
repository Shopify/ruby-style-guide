# frozen_string_literal: true

require "rubocop"

module RuboCop
  module Cop
    module Lint
      # Checks for the use of `rubocop:disable` and `rubocop:todo` comments.
      # This cop helps enforce code quality by preventing developers from
      # disabling other RuboCop rules, except for a configurable list of
      # allowed cops.
      class NoDisableComment < ::RuboCop::Cop::Base
        MSG = 'Avoid disabling RuboCop rules.'
        MSG_WITH_COP = 'Avoid disabling RuboCop rule `%<cops>s`.'

        DISABLE_OR_TODO_WITH_COPS_PATTERN = /\A#\s*rubocop:(?:disable|todo)\s+(.+)/i.freeze

        def on_new_investigation
          processed_source.comments.each do |comment|
            directive_comment = DirectiveComment.new(comment)
            next unless directive_comment.disabled?

            if directive_comment.all_cops?
              add_offense(comment)
              next
            end

            disallowed_cops = directive_comment.cop_names - allowed_cops
            next if disallowed_cops.empty?

            message = format(MSG_WITH_COP, cops: disallowed_cops.join(', '))

            add_offense(comment, message: message)
          end
        end

        private

        def extract_disabled_cops(comment_text)
          match = comment_text.match(DISABLE_OR_TODO_WITH_COPS_PATTERN)
          return [] unless match

          cops_string = match[1].strip
          # Handle both comma and space separated cop names
          cops_string.split(/[,\s]+/).map(&:strip).reject(&:empty?)
        end

        def allowed_cops
          cop_config.fetch('AllowedCops', [])
        end
      end
    end
  end
end
