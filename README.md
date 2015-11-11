---
layout: default
permalink: '/index.html'
---

# Ruby style guide

Ruby is the main language at Shopify. We are primarily a Ruby shop and we are
probably one of the largest out there. Ruby is the go-to language for new web
projects and scripting.

We expect all developers at Shopify to have at least a passing understanding of
Ruby. It's a great language. It will make you a better developer no matter what
you work in day to day. What follows is a loose coding style to follow while
developing in Ruby.


## General

* Make all lines of your methods operate on the same level of abstraction.
  (Single Level of Abstraction Principle)

* Code in a functional way. Avoid mutation (side effects) when you can.

* Do not program defensively. (See
  http://www.erlang.se/doc/programming_rules.shtml#HDR11).

* Do not mutate arguments unless that is the purpose of the method.

* Do not mess around in core classes when writing libraries.

* Keep the code simple.

* Don't overdesign.

* Don't underdesign.

* Avoid bugs.

* Be consistent.

* Use common sense.


## Formatting

* Use `UTF-8` as the source file encoding.

* Use 2 space indent, no tabs.

* Use Unix-style line endings.

* Don't use `;` to separate statements and expressions. As a corollary - use one
  expression per line.

* Use spaces around operators, after commas, colons and semicolons, around
  `{` and before `}`.

* No spaces after `(`, `[` and before `]`, `)`.

* No space after the `!` operator.

* No space inside range literals.

* Indent `when` as deep as `case`.

* Use empty lines between method definitions and also to break up methods into
  logical paragraphs internally.

* Use spaces around the `=` operator when assigning default values to method
  parameters.

* Avoid line continuation `\` where not required. In practice, avoid using line
  continuations for anything but string concatenation.

* Align the parameters of a method call, if they span more than one line, with
  one level of indentation relative to the start of the line with the method
  call.

    ```ruby
    # starting point (line is too long)
    def send_mail(source)
      Mailer.deliver(to: 'bob@example.com', from: 'us@example.com', subject: 'Important message', body: source.text)
    end

    # bad (double indent)
    def send_mail(source)
      Mailer.deliver(
          to: 'bob@example.com',
          from: 'us@example.com',
          subject: 'Important message',
          body: source.text)
    end

    # good
    def send_mail(source)
      Mailer.deliver(
        to: 'bob@example.com',
        from: 'us@example.com',
        subject: 'Important message',
        body: source.text
      )
    end
    ```

* Align the elements of array literals spanning multiple lines.

* Limit lines to 120 characters.

* Avoid trailing whitespace.

* End each file with a newline.

* Don't use block comments:

    ```ruby
    # bad
    =begin
    comment line
    another comment line
    =end

    # good
    # comment line
    # another comment line
    ```


## Syntax

* Use `::` only to reference constants(this includes classes and modules) and
  constructors (like `Array()` or `Nokogiri::HTML()`). Do not use `::` for
  regular method invocation.

* Use def with parentheses when there are parameters. Omit the parentheses when
  the method doesn't accept any parameters.

* Never use `for`, unless you know exactly why.

* Never use `then`.

* Favor the ternary operator(`?:`) over `if/then/else/end` constructs.

    ```ruby
    # bad
    result = if some_condition then something else something_else end

    # good
    result = some_condition ? something : something_else
    ```

* Use one expression per branch in a ternary operator. This also means that
  ternary operators must not be nested. Prefer if/else constructs in these
  cases.

* Use `when x then ...` for one-line cases.

* Use `!` instead of `not`.

* Don't use `and` and `or` keywords. Always use `&&` and `||` instead.

* Avoid multiline `?:` (the ternary operator); use `if/unless` instead.

* Favor modifier `if/unless` usage when you have a single-line body.


    ```ruby
    # bad
    if some_condition
      do_something
    end

    # good
    do_something if some_condition
    ```

* Favor `unless` over `if` for negative conditions.

* Do not use `unless` with `else`. Rewrite these with the positive case first.

* Omit parentheses around parameters for methods that are part of an internal
  DSL (e.g. Rake, Rails, RSpec), methods that have "keyword" status in Ruby
  (e.g. `attr_reader`, `puts`) and attribute access methods. Use parentheses
  around the arguments of all other method invocations.

* Omit the outer braces around an implicit options hash.

* Use the proc invocation shorthand when the invoked method is the only
  operation of a block.

    ```ruby
    # bad
    names.map { |name| name.upcase }

    # good
    names.map(&:upcase)
    ```

* Prefer `{...}` over `do...end` for single-line blocks. Avoid using `{...}` for
  multi-line blocks. Always use `do...end` for "control flow" and "method
  definitions" (e.g. in Rakefiles and certain DSLs). Avoid `do...end` when
  chaining.

* Avoid `return` where not required for control flow.

* Avoid `self` where not required (it is only required when calling a self
  write accessor).

* Using the return value of `=` is okay:

    ```ruby
    if v = /foo/.match(string) ...
    ```

* Use `||=` to initialize variables only if they're not already initialized.

* Don't use `||=` to initialize boolean variables (consider what would happen if
  the current value happened to be `false`).

    ```ruby
    # bad - would set enabled to true even if it was false
    @enabled ||= true

    # good
    @enabled = true if enabled.nil?

    # also valid - defined? workaround
    @enabled = true unless defined?(@enabled)
    ```

* Do not put a space between a method name and the opening parenthesis.

* Use the new lambda literal syntax for single-line body blocks. Use the lambda
  method for multi-line blocks.

    ```ruby
    # bad
    l = lambda { |a, b| a + b }
    l.call(1, 2)

    # good
    l = ->(a, b) { a + b }
    l.call(1, 2)

    l = lambda do |a, b|
      tmp = a * 7
      tmp * b / 50
    end
    ```

* Prefer `proc` over `Proc.new`.

* Prefix with `_` unused block parameters and local variables. It's also
  acceptable to use just `_`.

* Prefer a guard clause when you can assert invalid data. A guard clause is a
  conditional statement at the top of a function that bails out as soon as it
  can.

    ```ruby
    # bad
    def compute_thing(thing)
      if thing[:foo]
        update_with_bar(thing)
        if thing[:foo][:bar]
          partial_compute(thing)
        else
          re_compute(thing)
        end
      end
    end

    # good
    def compute_thing(thing)
      return unless thing[:foo]
      update_with_bar(thing[:foo])
      return re_compute(thing) unless thing[:foo][:bar]
      partial_compute(thing)
    end
    ```

* Use non-OO regexps (they won't make the code better).  Freely use `=~`,
  `$0-9`, `$~`, `$\` and `$'` when needed.

* Prefer keyword arguments over options hash.

* Prefer `map` over `collect`, `find` over `detect`, `select` over `find_all`,
  `size` over `length`.


## Naming

* Use `snake_case` for symbols, methods and variables.

* Use `CamelCase` for classes and modules (keep acronyms like HTTP, RFC, XML
  uppercase).

* Use `snake_case` for naming files and directories, e.g. `hello_world.rb`.

* Aim to have just a single class/module per source file. Name the file name
  as the class/module, but replacing `CamelCase` with `snake_case`.

* Use `SCREAMING_SNAKE_CASE` for other constants.

* When using inject with short blocks, name the arguments according to what is
  being injected, e.g. `|hash, e|` (mnemonic: hash, element)

* When defining binary operators, name the parameter `other`(`<<` and `[]` are
  exceptions to the rule, since their semantics are different).

* The names of predicate methods (methods that return a boolean value) should
  end in a question mark. (i.e. `Array#empty?`). Methods that don't return a
  boolean, shouldn't end in a question mark.


## Comments

* Comments longer than a word are capitalized and use punctuation.

* Avoid superfluous comments.

* If you really need them, could you instead clarify your code?


## Classes & Modules

* Prefer modules to classes with only class methods. Classes should be used
  only when it makes sense to create instances out of them.

    ```ruby
    # bad
    class SomeClass
      def self.some_method
        # body omitted
      end

      def self.some_other_method
      end
    end

    # good
    module SomeModule
      module_function

      def some_method
        # body omitted
      end

      def some_other_method
      end
    end
    ```

* Favor the use of `module_function` over `extend self` when you want to turn a
  module's instance methods into class methods.

* When designing class hierarchies make sure that they conform to the [Liskov
  Substitution
  Principle](https://en.wikipedia.org/wiki/Liskov_substitution_principle).

* Use the [`attr` family of methods](http://ruby-doc.org/core-2.2.3/Module.html#method-i-attr_accessor)
  to define trivial accessors or mutators.

    ```ruby
    # bad
    class Person
      def initialize(first_name, last_name)
        @first_name = first_name
        @last_name = last_name
      end

      def first_name
        @first_name
      end

      def last_name
        @last_name
      end
    end

    # good
    class Person
      attr_reader :first_name, :last_name

      def initialize(first_name, last_name)
        @first_name = first_name
        @last_name = last_name
      end
    end
    ```

* Avoid the use of `attr`. Use `attr_reader` and `attr_accessor` instead.

* Avoid the usage of class (`@@`) variables due to their "nasty" behavior in
  inheritance.

* Indent the `public`, `protected`, and `private` methods as much as the method
  definitions they apply to. Leave one blank line above the visibility modifier
  and one blank line below in order to emphasize that it applies to all methods
  below it.

    ```ruby
    class SomeClass
      def public_method
        # ...
      end

      private

      def private_method
        # ...
      end

      def another_private_method
        # ...
      end
    end
    ```

* Avoid `alias` when `alias_method` will do.


## Exceptions

* Signal exceptions using the `raise` method.

* Don't specify `RuntimeError` explicitly in the two argument version of
  `raise`.

    ```ruby
    # bad
    raise RuntimeError, 'message'

    # good - signals a RuntimeError by default
    raise 'message'
    ```

* Prefer supplying an exception class and a message as two separate arguments
  to `raise`, instead of an exception instance.

    ```ruby
    # bad
    raise SomeException.new('message')
    # Note that there is no way to do `raise SomeException.new('message'), backtrace`.

    # good
    raise SomeException, 'message'
    # Consistent with `raise SomeException, 'message', backtrace`.
    ```

* Do not return from an `ensure` block. If you explicitly return from a method
  inside an `ensure` block, the return will take precedence over any exception
  being raised, and the method will return as if no exception had been raised at
  all. In effect, the exception will be silently thrown away.

    ```ruby
    def foo
      raise
    ensure
      return 'very bad idea'
    end
    ```

* Use *implicit begin blocks* where possible.

    ```ruby
    # bad
    def foo
      begin
        # main logic goes here
      rescue
        # failure handling goes here
      end
    end

    # good
    def foo
      # main logic goes here
    rescue
      # failure handling goes here
    end
    ```

* Don't suppress exceptions.

    ```ruby
    # bad
    begin
      # an exception occurs here
    rescue SomeError
      # the rescue clause does absolutely nothing
    end

    # bad - `rescue nil` swallows all errors, including syntax errors, and
    # makes them hard to track down.
    do_something rescue nil
    ```

* Avoid using `rescue` in its modifier form.

    ```ruby
    # bad - this catches exceptions of StandardError class and its descendant classes
    read_file rescue handle_error($!)

    # good - this catches only the exceptions of Errno::ENOENT class and its descendant classes
    def foo
      read_file
    rescue Errno::ENOENT => error
      handle_error(error)
    end
    ```

* Avoid rescuing the `Exception` class.

    ```ruby
    # bad
    begin
      # calls to exit and kill signals will be caught (except kill -9)
      exit
    rescue Exception
      puts "you didn't really want to exit, right?"
      # exception handling
    end

    # good
    begin
      # a blind rescue rescues from StandardError, not Exception.
    rescue => error
      # exception handling
    end
    ```

* Favor the use of exceptions for the standard library over introducing new
  exception classes.

* Don't use single letter variables for exceptions (`error` isn't that hard to
  type).

    ```ruby
    # bad
    begin
      # an exception occurs here
    rescue => e
      # exception handling
    end

    # good
    begin
      # an exception occurs here
    rescue => error
      # exception handling
    end
    ```


## Collections

* Prefer literal array and hash creation notation (unless you need to pass
  parameters to their constructors, that is).

    ```ruby
    # bad
    arr = Array.new
    hash = Hash.new

    # good
    arr = []
    hash = {}
    ```

* Prefer `%w` to the literal array syntax when you need an array of words
  (non-empty strings without spaces and special characters in them).  Apply this
  rule only to arrays with two or more elements.

    ```ruby
    # bad
    STATES = ['draft', 'open', 'closed']

    # good
    STATES = %w(draft open closed)
    ```

* Prefer `%i` to the literal array syntax when you need an array of symbols.
  Apply this rule only to arrays with two or more elements.

    ```ruby
    # bad
    STATES = [:draft, :open, :closed]

    # good
    STATES = %i(draft open closed)
    ```

* When accessing the first or last element from an array, prefer `first` or
  `last` over `[0]` or `[-1]`.

* Avoid the use of mutable objects as hash keys.

* Use the Ruby 1.9 hash literal syntax when your hash keys are symbols.

* Use `Hash#key?` instead of `Hash#has_key?` and `Hash#value?` instead of
  `Hash#has_value?`. As noted
  [here](http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-core/43765) by
  Matz, the longer forms are considered deprecated.

    ```ruby
    # bad
    hash.has_key?(:test)
    hash.has_value?(value)

    # good
    hash.key?(:test)
    hash.value?(value)
    ```

* Use `Hash#fetch` when dealing with hash keys that should be present.

    ```ruby
    heroes = { batman: 'Bruce Wayne', superman: 'Clark Kent' }
    # bad - if we make a mistake we might not spot it right away
    heroes[:batman] # => "Bruce Wayne"
    heroes[:supermann] # => nil

    # good - fetch raises a KeyError making the problem obvious
    heroes.fetch(:supermann)
    ```

* Introduce default values for hash keys via `Hash#fetch` as opposed to using
  custom logic.

    ```ruby
    batman = { name: 'Bruce Wayne', is_evil: false }

    # bad - if we just use || operator with falsy value we won't get the expected result
    batman[:is_evil] || true # => true

    # good - fetch work correctly with falsy values
    batman.fetch(:is_evil, true) # => false
    ```


## The rest

* Avoid hashes-as-optional-parameters in general. Does the method do too much?

* Avoid long methods.

* Avoid long parameter lists.

* Use `def self.method` to define singleton methods.

* Avoid needless metaprogramming.

* Never start a method with `get_`.

* Never use a `!` at the end of a method name if you have no equivalent method
  without the bang. Methods are expected to change internal object state; you
  don't need a bang for that. Bangs are to mark a more dangerous version of a
  method, e.g. `save` returns a `bool` in ActiveRecord, whereas `save!` will
  throw an exception on failure.

* Avoid using `update_all`. If you do use it, use a scoped association
  (`Shop.where(amount: nil).update_all(amount: 0)`) instead of the two-argument
  version (`Shop.update_all({amount: 0}, amount: nil)`). But seriously, you
  probably shouldn't be doing it in the first place.

* Avoid using `flunk` if an `assert_*` or `refute_*` family method will suffice.

* Avoid using `refute_*` if an `assert_*` can do.
