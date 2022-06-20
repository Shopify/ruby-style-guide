# frozen_string_literal: true

require "minitest/autorun"
require "pry-byebug"

module Warning
  def self.warn(message)
    # Remove once https://github.com/samg/diffy/pull/118 is merged
    return if message =~ %r{lib/diffy/diff.rb:\d*: warning: assigned but unused variable - (?:stderr|process_status)}

    raise message.to_s
  end
end
Warning[:deprecated] = true
