# frozen_string_literal: true

require "minitest/autorun"

require "rubocop-shopify"

module Warning
  class << self
    def warn(message)
      raise message.to_s
    end
  end
end
Warning[:deprecated] = true
