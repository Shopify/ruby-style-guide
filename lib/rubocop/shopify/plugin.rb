# frozen_string_literal: true

require "lint_roller"

module RuboCop
  module Shopify
    class Plugin < LintRoller::Plugin
      def about
        LintRoller::About.new(
          name: "rubocop-shopify",
          version: RuboCop::Shopify::VERSION,
          homepage: "https://github.com/Shopify/rubocop-shopify",
          description: "A plugin for RuboCop to enforce Shopify-specific coding standards."
        )
      end

      def supported?(context)
        context.engine == :rubocop
      end

      def rules(context)
        LintRoller::Rules.new(
          type: :path,
          config_format: :rubocop,
          value: File.expand_path("../../../config/default.yml", __dir__)
        )
      end
    end
  end
end
