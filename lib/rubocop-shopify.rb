# frozen_string_literal: true

require "rubocop"
require "rubocop/shopify/version"
require "rubocop/shopify/plugin"

RuboCop::Cop::Lint.register_cop :NoReturnInMemoization, "#{__dir__}/rubocop/cop/lint/no_return_in_memoization"
RuboCop::Cop::Style.register_cop :ProcCaseWhen, "#{__dir__}/rubocop/cop/style/proc_case_when"
