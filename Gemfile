# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "diffy"
gem "minitest"
gem "pry-byebug"
gem "rake"
gem "rubocop-minitest"

# Fixes the following warning on Ruby 3.3:
#   base64 was loaded from the standard library, but will no longer be part of the default gems since Ruby 3.4.0.
#   Add base64 to your Gemfile or gemspec. Also contact author of rubocop-1.53.0 to add base64 into its gemspec.
# Check if this is still necessary when the minimum RuboCop version is increased.
gem "base64"
