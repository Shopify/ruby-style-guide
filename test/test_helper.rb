# frozen_string_literal: true

require "minitest/autorun"
require "pry-byebug"

module Warning
  def self.warn(message)
    raise message.to_s
  end
end
Warning[:deprecated] = true
