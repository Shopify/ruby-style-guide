# frozen_string_literal: true

# Once rubocop#13833 is merged, and we update our minimum RuboCop version, this will be true for everyone.
return if RuboCop::ConfigValidator::COMMON_PARAMS.include?('Reference')

module RuboCop
  module Shopify
    # Forward-port of https://github.com/rubocop/rubocop/pull/13833, until it's merged.
    #
    # In the meantime, this allow us to specify a `Reference` for all cops, regardless of it the defaults include one.
    #
    # Once the PR is merged, released, and we update our minimum RuboCop version, we can remove this file.
    module RubocopReferenceCommonParamForwardport
      # AFAICT we can only do this through side effects. Still, we put them in this module to keep it organized.
      RuboCop::ConfigValidator::COMMON_PARAMS = [
        *RuboCop::ConfigValidator.send(:remove_const, :COMMON_PARAMS),
        "Reference",
      ].freeze
    end
  end
end
