# frozen_string_literal: true

# rubocop:disable Lint/UselessAssignment

# Prefer the literal array syntax over `%w` or `%i`.
word_array_percent = ["red", "blue", "white"] # vs %w[red blue white]

# Use literal array and hash creation notation unless you need to pass
# parameters to their constructors.
arr = []
hash = {}

# Append a trailing comma in multi-line collection literals.
multi_line_collection_trailing_comma = {
  foo: :bar,
  baz: :toto,
}

# Struct over OpenStructUse
point = Struct.new(:x, :y) # vs OpenStruct.new(x: 0, y: 1)
point = Point.new(0, 1)

# Avoid space in lambda literals.
a = ->(x, y) { x + y }
