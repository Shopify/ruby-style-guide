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


## The rest

* Prefer using `hash.fetch(:key)` over `hash[:key]` when you expect `:key` to be
  set. This will lead to better error messages and stack traces when it isn't.
  ([longer rationale](http://www.bitzesty.com/blog/2014/5/19/hashfetch-in-ruby-development))

* Prefer using `hash.fetch(:key, nil)` over `hash[:key]` when `:key` may not be
  set and `nil` is the default value you want to use in that case.

* Avoid using modules whenever possible, especially if it is only used in one
  place. If you really need to encapsulate the code you should be creating a
  class.

* Avoid hashes-as-optional-parameters in general. Does the method do too much?

* Avoid long methods.

* Avoid long parameter lists.

* Use `def self.method` to define singleton methods.

* Avoid `alias` when `alias_method` will do.

* Avoid needless metaprogramming.

* Never start a method with `get_`.

* Never use a `!` at the end of a method name if you have no equivalent method
  without the bang. Methods are expected to change internal object state; you
  don't need a bang for that. Bangs are to mark a more dangerous version of a
  method, e.g. `save` returns a `bool` in ActiveRecord, whereas `save!` will
  throw an exception on failure.

* Avoid using `rescue nil`. It swallows all errors, including syntax errors, and
  makes them hard to track down.

* Avoid using `update_all`. If you do use it, use a scoped association
  (`Shop.where(amount: nil).update_all(amount: 0)`) instead of the two-argument
  version (`Shop.update_all({amount: 0}, amount: nil)`). But seriously, you
  probably shouldn't be doing it in the first place.

* Avoid using `flunk` if an `assert_*` or `refute_*` family method will suffice.

* Avoid using `refute_*` if an `assert_*` can do.
