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

<a name="single-level-of-abstraction"></a>
* Make all lines of your methods operate on the same level of abstraction. (Single Level of Abstraction Principle)
<sup>[[link](#single-level-of-abstraction)]</sup>

<a name="functional-code"></a>
* Code in a functional way. Avoid mutation (side effects) when you can.
<sup>[[link](#functional-code)]</sup>

<a name="no-defensive-programming"></a>
* Do not program defensively (see <http://www.erlang.se/doc/programming_rules.shtml#HDR11>).
<sup>[[link](#no-defensive-programming)]</sup>

<a name="no-argument-mutation"></a>
* Do not mutate arguments unless that is the purpose of the method.
<sup>[[link](#no-argument-mutation)]</sup>

<a name="no-monkeypatch-ruby-core-in-libraries"></a>
* Do not mess around in / monkeypatch core classes when writing libraries.
<sup>[[link](#no-monkeypatch-ruby-core-in-libraries)]</sup>

<a name="simple"></a>
* Keep the code simple.
<sup>[[link](#simple)]</sup>

<a name="overdesign"></a>
* Don't overdesign.
<sup>[[link](#overdesign)]</sup>

<a name="underdesign"></a>
* Don't underdesign.
<sup>[[link](#underdesign)]</sup>

<a name="avoid-bugs"></a>
* Avoid bugs.
<sup>[[link](#avoid-bugs)]</sup>

<a name="consistent"></a>
* Be consistent.
<sup>[[link](#consistent)]</sup>

<a name="common-sense"></a>
* Use common sense.
<sup>[[link](#common-sense)]</sup>

## Formatting

<a name="utf8-source"></a>
* Use `UTF-8` as the source file encoding.
<sup>[[link](#utf8-source)]</sup>

<a name="two-space-indent"></a>
* Use 2 space indent, no tabs.
<sup>[[link](#two-space-indent)]</sup>

<a name="unix-style-line-endings"></a>
* Use Unix-style line endings.
<sup>[[link](#unix-style-line-endings)]</sup>

<a name="no-multi-expressions-in-one-line"></a>
* Don't use `;` to separate statements and expressions. As a corollary - use one expression per line.
<sup>[[link](#no-multi-expressions-in-one-line)]</sup>

<a name="use-space-around-operators"></a>
* Use spaces around operators, after commas, colons and semicolons, around `{` and before `}`.
<sup>[[link](#use-space-around-operators)]</sup>

<a name="no-space-after-braces"></a>
* No spaces after `(`, `[` and before `]`, `)`.
<sup>[[link](#no-space-after-braces)]</sup>

<a name="no-space-before-exclamation"></a>
* No space after the `!` operator.
<sup>[[link](#no-space-before-exclamation)]</sup>

<a name="no-space-inside-range-literals"></a>
* No space inside range literals.
<sup>[[link](#no-space-inside-range-literals)]</sup>

<a name="indent-when-to-case"></a>
* Indent `when` as deep as the `case` line.
<sup>[[link](#indent-when-to-case)]</sup>

<a name="indent-conditional-assignment"></a>
* When assigning the result of a conditional expression to a variable, align its branches with the variable that
    receives the return value.
<sup>[[link](#indent-conditional-assignment)]</sup>

  ~~~ ruby
  # bad
  result =
    if some_cond
      # ...
      # ...
      calc_something
    else
      calc_something_else
    end

  # good
  result = if some_cond
    # ...
    # ...
    calc_something
  else
    calc_something_else
  end
  ~~~

<a name="intetional-empty-lines"></a>
* Use empty lines between method definitions and also to break up methods into logical paragraphs internally.
<sup>[[link](#intetional-empty-lines)]</sup>

<a name="space-around-assignment-operator"></a>
* Use spaces around the `=` operator when assigning default values to method parameters.
<sup>[[link](#space-around-assignment-operator)]</sup>

<a name="avoid-line-continuation"></a>
* Avoid line continuation `\` where not required. In practice, avoid using line continuations for anything but string
    concatenation.
<sup>[[link](#avoid-line-continuation)]</sup>

<a name="align-parameters-of-method-call"></a>
* Align the parameters of a method call, if they span more than one line, with one level of indentation relative to
    the start of the line with the method call.
<sup>[[link](#align-parameters-of-method-call)]</sup>

  ~~~ ruby
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
      body: source.text,
    )
  end
  ~~~

<a name="multiline-method-call-indentation"></a>
* When chaining methods on multiple lines, indent successive calls by one level of indentation.
<sup>[[link](#multiline-method-call-indentation)]</sup>

  ~~~ ruby
  # bad (indented to the previous call)
  User.pluck(:name)
      .sort(&:casecmp)
      .chunk { |n| n[0] }

  # good
  User
    .pluck(:name)
    .sort(&:casecmp)
    .chunk { |n| n[0] }
  ~~~

<a name="array-literal-indentation"></a>
* Align the elements of array literals spanning multiple lines.
<sup>[[link](#array-literal-indentation)]</sup>

<a name="line-length"></a>
* Limit lines to 120 characters.
<sup>[[link](#line-length)]</sup>

<a name="avoid-trailing-whitespace"></a>
* Avoid trailing whitespace.
<sup>[[link](#avoid-trailing-whitespace)]</sup>

<a name="avoid-extra-whitespace"></a>
* Avoid extra whitespace, except for alignment purposes.
<sup>[[link](#avoid-extra-whitespace)]</sup>

<a name="newline-at-end-of-line"></a>
* End each file with a newline.
<sup>[[link](#newline-at-end-of-line)]</sup>

<a name="no-block-comments"></a>
* Don't use block comments:
<sup>[[link](#no-block-comments)]</sup>

  ~~~ ruby
  # bad
  =begin
  comment line
  another comment line
  =end

  # good
  # comment line
  # another comment line
  ~~~

<a name="closing-brace-location-of-method-call"></a>
* Closing method call brace must be on the line after the last argument when opening brace is on a separate line from
    the first argument.
<sup>[[link](#closing-brace-location-of-method-call)]</sup>

  ~~~ ruby
  # bad
  method(
    arg_1,
    arg_2)

  # good
  method(
    arg_1,
    arg_2,
  )
  ~~~


## Syntax

<a name="double-colon-for-constants"></a>
* Use `::` only to reference constants (this includes classes and modules) and constructors (like `Array()` or
    `Nokogiri::HTML()`). Do not use `::` for regular method invocation.
<sup>[[link](#double-colon-for-constants)]</sup>

<a name="avoid-double-colon-for-definitions"></a>
* Avoid using `::` for defining class and modules, or for inheritance, since constant lookup will not search in parent
    classes/modules.
<sup>[[link](#avoid-double-colon-for-definitions)]</sup>

  ~~~ ruby
  # bad
  module A
    FOO = 'test'
  end

  class A::B
    puts FOO  # this will raise a NameError exception
  end

  # good
  module A
    FOO = 'test'

    class B
      puts FOO
    end
  end
  ~~~

<a name="def-parens"></a>
* Use def with parentheses when there are parameters. Omit the parentheses when the method doesn't accept any
    parameters.
<sup>[[link](#def-parens)]</sup>

<a name="never-use-for"></a>
* Never use `for`, unless you know exactly why.
<sup>[[link](#never-use-for)]</sup>

<a name="never-use-then"></a>
* Never use `then`.
<sup>[[link](#never-use-then)]</sup>

<a name="ternary-operator"></a>
* Favour the ternary operator(`?:`) over `if/then/else/end` constructs.
<sup>[[link](#ternary-operator)]</sup>

  ~~~ ruby
  # bad
  result = if some_condition then something else something_else end

  # good
  result = some_condition ? something : something_else
  ~~~

<a name="no-nested-ternary"></a>
* Use one expression per branch in a ternary operator. This also means that ternary operators must not be nested.
    Prefer if/else constructs in these cases.
<sup>[[link](#no-nested-ternary)]</sup>

<a name="one-line-cases"></a>
* Use `when x then ...` for one-line cases.
<sup>[[link](#one-line-cases)]</sup>

<a name="prefer-exclamation-over-not"></a>
* Use `!` instead of `not`.
<sup>[[link](#prefer-exclamation-over-not)]</sup>

<a name="prefer-symbol-logical-operators"></a>
* Prefer `&&`/`||` over `and`/`or`. [More info on `and/or` for control
    flow](http://devblog.avdi.org/2014/08/26/how-to-use-rubys-english-andor-operators-without-going-nuts/).
<sup>[[link](#prefer-symbol-logical-operators)]</sup>

<a name="avoid-multiline-ternary"></a>
* Avoid multiline `?:` (the ternary operator); use `if/unless` instead.
<sup>[[link](#avoid-multiline-ternary)]</sup>

<a name="favour-unless-over-negative-if"></a>
* Favour `unless` over `if` for negative conditions.
<sup>[[link](#favour-unless-over-negative-if)]</sup>

<a name="dont-use-unless-with-else"></a>
* Do not use `unless` with `else`. Rewrite these with the positive case first.
<sup>[[link](#dont-use-unless-with-else)]</sup>

<a name="use-parens-around-arguments-for-method-calls"></a>
* Use parentheses around the arguments of method invocations. Omit parentheses when not providing arguments. Also omit parentheses when the invocation is single-line and the method:
  <sup>[[link](#use-parens-around-arguments-for-method-calls)]</sup>

  - is a class method call with implicit receiver

    ~~~ ruby
    # bad
    class User
      include(Bar)
      has_many(:posts)
    end

    # good
    class User
      include Bar
      has_many :posts
      SomeClass.some_method(:foo)
    end
    ~~~

  - is one of the following methods:
    * `require`
    * `require_relative`
    * `require_dependency`
    * `yield`
    * `raise`
    * `puts`

<a name="prefer-class-method-over-rails-scope"></a>
* Use class methods instead of a rails scope with a multi-line lambda
<sup>[[link](#prefer-class-method-over-rails-scope)]</sup>

  ~~~ ruby
  # bad
  scope(:pending, -> do
    ...
    ...
  end)

  # good
  def self.pending
    ...
    ...
  end
  ~~~

<a name="omit-outer-braces-implicit-options-hash"></a>
* Omit the outer braces around an implicit options hash.
<sup>[[link](#omit-outer-braces-implicit-options-hash)]</sup>

<a name="use-proc-shothand"></a>
* Use the proc invocation shorthand when the invoked method is the only operation of a block.
<sup>[[link](#use-proc-shothand)]</sup>

  ~~~ ruby
  # bad
  names.map { |name| name.upcase }

  # good
  names.map(&:upcase)
  ~~~

<a name="style-of-blocks"></a>
* Prefer `{...}` over `do...end` for single-line blocks. Avoid using `{...}` for multi-line blocks. Always use
    `do...end` for "control flow" and "method definitions" (e.g. in Rakefiles and certain DSLs). Avoid `do...end` when
    chaining.
<sup>[[link](#style-of-blocks)]</sup>

<a name="avoid-return-other-than-control-flow"></a>
* Avoid `return` where not required for control flow.
<sup>[[link](#avoid-return-other-than-control-flow)]</sup>

<a name="avoid-self"></a>
* Avoid `self` where not required (it is only required when calling a self write accessor).
<sup>[[link](#avoid-self)]</sup>

<a name="assignment-in-condition"></a>
* Using the return value of `=` is okay:
<sup>[[link](#assignment-in-condition)]</sup>

  ~~~ ruby
  if v = /foo/.match(string) ...
  ~~~

<a name="double-pipe-for-uninit"></a>
* Use `||=` to initialize variables only if they're not already initialized.
<sup>[[link](#double-pipe-for-uninit)]</sup>

<a name="no-double-pipes-for-bools"></a>
* Don't use `||=` to initialize boolean variables (consider what would happen if the current value happened to be
    `false`).
<sup>[[link](#no-double-pipes-for-bools)]</sup>

  ~~~ ruby
  # bad - would set enabled to true even if it was false
  @enabled ||= true

  # good
  @enabled = true if enabled.nil?

  # also valid - defined? workaround
  @enabled = true unless defined?(@enabled)
  ~~~

<a name="parens-no-spaces"></a>
* Do not put a space between a method name and the opening parenthesis.
<sup>[[link](#parens-no-spaces)]</sup>

<a name="use-lambda-literal"></a>
* Use the new lambda literal syntax.
<sup>[[link](#use-lambda-literal)]</sup>

  ~~~ ruby
  # bad
  l = lambda { |a, b| a + b }
  l.call(1, 2)

  l = lambda do |a, b|
    tmp = a * 7
    tmp * b / 50
  end

  # good
  l = ->(a, b) { a + b }
  l.call(1, 2)

  l = ->(a, b) do
    tmp = a * 7
    tmp * b / 50
  end
  ~~~

<a name="proc"></a>
* Prefer `proc` over `Proc.new`.
<sup>[[link](#proc)]</sup>

<a name="underscore-unused-block-params-and-vars"></a>
* Prefix with `_` unused block parameters and local variables. It's also acceptable to use just `_`.
<sup>[[link](#underscore-unused-block-params-and-vars)]</sup>

<a name="prefer-guard-for-assertion"></a>
* Prefer a guard clause when you can assert invalid data. A guard clause is a conditional statement at the top of a
    function that bails out as soon as it can.
<sup>[[link](#prefer-guard-for-assertion)]</sup>

  ~~~ ruby
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
  ~~~

<a name="no-optional-hash-params"></a>
* Avoid hashes-as-optional-parameters in general. Does the method do too much?
<sup>[[link](#no-optional-hash-params)]</sup>

<a name="prefer-keyword-arguments"></a>
* Prefer keyword arguments over options hash.
<sup>[[link](#prefer-keyword-arguments)]</sup>

<a name="map-find-select-size"></a>
* Prefer `map` over `collect`, `find` over `detect`, `select` over `find_all`, `size` over `length`.
<sup>[[link](#map-find-select-size)]</sup>

<a name="prefer-time-over-datetime"></a>
* Prefer `Time` over `DateTime` since it supports proper time zones instead of
  UTC offsets. [More info](https://gist.github.com/pixeltrix/e2298822dd89d854444b).
<sup>[[link](#prefer-time-over-datetime)]</sup>

<a name="prefer-time-iso8601-over-parse"></a>
* Prefer `Time.iso8601(foo)` instead of `Time.parse(foo)` when expecting ISO8601 formatted
  time strings like `"2018-03-20T11:16:39-04:00"`.
<sup>[[link](#prefer-time-iso8601-over-parse)]</sup>

## Naming

<a name="snake-case-symbols-methods-vars"></a>
* Use `snake_case` for symbols, methods and variables.
<sup>[[link](#snake-case-symbols-methods-vars)]</sup>

<a name="camelcase-classes"></a>
* Use `CamelCase` for classes and modules (keep acronyms like HTTP, RFC, XML uppercase).
<sup>[[link](#camelcase-classes)]</sup>

<a name="snake-case-files-directories"></a>
* Use `snake_case` for naming files and directories, e.g. `hello_world.rb`.
<sup>[[link](#snake-case-files-directories)]</sup>

<a name="one-class-per-file"></a>
* Aim to have just a single class/module per source file. Name the file name as the class/module, but replacing
    `CamelCase` with `snake_case`.
<sup>[[link](#one-class-per-file)]</sup>

<a name="screaming-snake-case"></a>
* Use `SCREAMING_SNAKE_CASE` for other constants.
<sup>[[link](#screaming-snake-case)]</sup>

<a name="inject-argument-naming"></a>
* When using inject with short blocks, name the arguments according to what is being injected, e.g. `|hash, e|`
    (mnemonic: hash, element)
<sup>[[link](#inject-argument-naming)]</sup>

<a name="other-argument"></a>
* When defining binary operators, name the parameter `other`(`<<` and `[]` are exceptions to the rule, since their
    semantics are different).
<sup>[[link](#other-argument)]</sup>

<a name="question-mark-and-preticate"></a>
* The names of predicate methods (methods that return a boolean value) should end in a question mark (i.e.
    `Array#empty?`). Methods that don't return a boolean, shouldn't end in a question mark.
<sup>[[link](#question-mark-and-preticate)]</sup>

<a name="avoid_is_underscroe"></a>
* Method names should not be prefixed with `is_`. E.g. prefer `empty?` over `is_empty?`.
<sup>[[link](#avoid_is_underscroe)]</sup>

<a name="avoid_magic_numbers"></a>
* Avoid magic numbers. Use a constant and give it a useful name.
<sup>[[link](#avoid_magic_numbers)]</sup>

## Comments

<a name="good-comments-for-reader"></a>
* Good comments focus on the reader of the code, by helping them understand the code. The reader may not have the same
    understanding, experience and knowledge as you. As a writer, take this into account.
<sup>[[link](#good-comments-for-reader)]</sup>

<a name="refactor-comments"></a>
* A big problem with comments is that they can get out of sync with the code easily. When refactoring code, refactor
    the surrounding comments as well.
<sup>[[link](#refactor-comments)]</sup>

<a name="good-copy"></a>
* Write good copy, and use proper capitalization and punctuation.
<sup>[[link](#good-copy)]</sup>

<a name="focus-on-why-not-how"></a>
* Focus on **why** your code is the way it is if this is not obvious, not **how** your code works.
<sup>[[link](#focus-on-why-not-how)]</sup>

<a name="clear-comments"></a>
* Avoid superfluous comments. If they are about how your code works, should you clarify your code instead?
<sup>[[link](#clear-comments)]</sup>

* For a good discussion on the costs and benefits of comments, see <http://c2.com/cgi/wiki?CommentCostsAndBenefits>.

## Classes & Modules

<a name="modules-vs-classes"></a>
* Prefer modules to classes with only class methods. Classes should be used only when it makes sense to create
    instances out of them.
<sup>[[link](#modules-vs-classes)]</sup>

<a name="favour-extend-self-over-module_function"></a>
* Favour the use of `extend self` over `module_function` when you want to turn a module's instance methods into class
    methods.
<sup>[[link](#favour-extend-self-over-module_function)]</sup>

  ~~~ ruby
  # bad
  module SomeModule
    module_function

    def some_method
    end

    def some_other_method
    end
  end

  # good
  module SomeModule
    extend self

    def some_method
    end

    def some_other_method
    end
  end
  ~~~

<a name="class-method-definitions"></a>
* Use a `class << self` block over `def self.` when defining class methods, and group them together within a single
    block.
<sup>[[link](#class-method-definitions)]</sup>

  ~~~ ruby
  # bad
  class SomeClass
    def self.method1
    end

    def method2
    end

    private

    def method3
    end

    def self.method4 # this is actually not private
    end
  end

  # good
  class SomeClass
    class << self
      def method1
      end

      private

      def method4
      end
    end

    def method2
    end

    private

    def method3
    end
  end
  ~~~

<a name="class-hierarchies"></a>
* When designing class hierarchies make sure that they conform to the [Liskov Substitution
    Principle](https://en.wikipedia.org/wiki/Liskov_substitution_principle).
<sup>[[link](#class-hierarchies)]</sup>

<a name="use-attr-methods"></a>
* Use the [`attr` family of methods](http://ruby-doc.org/core-2.2.3/Module.html#method-i-attr_accessor) to define
    trivial accessors or mutators.
<sup>[[link](#use-attr-methods)]</sup>

  ~~~ ruby
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
  ~~~

<a name="avoid-attr"></a>
* Avoid the use of `attr`. Use `attr_reader` and `attr_accessor` instead.
<sup>[[link](#avoid-attr)]</sup>

<a name="avoid-class-variable"></a>
* Avoid the usage of class (`@@`) variables due to their "nasty" behavior in inheritance.
<sup>[[link](#avoid-class-variable)]</sup>

<a name="indent-public-private-protected"></a>
* Indent the `public`, `protected`, and `private` methods as much as the method definitions they apply to. Leave one
    blank line above the visibility modifier and one blank line below in order to emphasize that it applies to all
    methods below it.
<sup>[[link](#indent-public-private-protected)]</sup>

  ~~~ ruby
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
  ~~~

<a name="avoid-alias"></a>
* Avoid `alias` when `alias_method` will do.
<sup>[[link](#avoid-alias)]</sup>


## Exceptions

<a name="use-raise"></a>
* Signal exceptions using the `raise` method.
<sup>[[link](#use-raise)]</sup>

<a name="no-explicit-runtimeerror"></a>
* Don't specify `RuntimeError` explicitly in the two argument version of `raise`.
<sup>[[link](#no-explicit-runtimeerror)]</sup>

  ~~~ ruby
  # bad
  raise RuntimeError, 'message'

  # good - signals a RuntimeError by default
  raise 'message'
  ~~~

<a name="exception-class-messages"></a>
* Prefer supplying an exception class and a message as two separate arguments to `raise`, instead of an exception
    instance.
<sup>[[link](#exception-class-messages)]</sup>

  ~~~ ruby
  # bad
  raise SomeException.new('message')
  # Note that there is no way to do `raise SomeException.new('message'), backtrace`.

  # good
  raise SomeException, 'message'
  # Consistent with `raise SomeException, 'message', backtrace`.
  ~~~

<a name="no-return-ensure"></a>
* Do not return from an `ensure` block. If you explicitly return from a method inside an `ensure` block, the return
    will take precedence over any exception being raised, and the method will return as if no exception had been raised
    at all. In effect, the exception will be silently thrown away.
<sup>[[link](#no-return-ensure)]</sup>

  ~~~ ruby
  def foo
    raise
  ensure
    return 'very bad idea'
  end
  ~~~

<a name="implicit-begin"></a>
* Use *implicit begin blocks* where possible.
<sup>[[link](#implicit-begin)]</sup>

  ~~~ ruby
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
  ~~~

<a name="dont-hide-exceptions"></a>
* Don't suppress exceptions.
<sup>[[link](#dont-hide-exceptions)]</sup>

  ~~~ ruby
  # bad
  begin
    # an exception occurs here
  rescue SomeError
    # the rescue clause does absolutely nothing
  end

  # bad - `rescue nil` swallows all errors, including syntax errors, and
  # makes them hard to track down.
  do_something rescue nil
  ~~~

<a name="no-rescue-modifiers"></a>
* Avoid using `rescue` in its modifier form.
<sup>[[link](#no-rescue-modifiers)]</sup>

  ~~~ ruby
  # bad - this catches exceptions of StandardError class and its descendant classes
  read_file rescue handle_error($!)

  # good - this catches only the exceptions of Errno::ENOENT class and its descendant classes
  def foo
    read_file
  rescue Errno::ENOENT => error
    handle_error(error)
  end
  ~~~

<a name="no-rescue-exception-class"></a>
* Avoid rescuing the `Exception` class.
<sup>[[link](#no-rescue-exception-class)]</sup>

  ~~~ ruby
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
  ~~~

<a name="standard-exceptions"></a>
* Favour the use of exceptions from the standard library over introducing new exception classes.
<sup>[[link](#standard-exceptions)]</sup>

<a name="meaningful-exception-name"></a>
* Don't use single letter variables for exceptions (`error` isn't that hard to type).
<sup>[[link](#meaningful-exception-name)]</sup>

  ~~~ ruby
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
  ~~~


## Collections

<a name="literal-array-hash"></a>
* Prefer literal array and hash creation notation (unless you need to pass parameters to their constructors, that is).
<sup>[[link](#literal-array-hash)]</sup>

  ~~~ ruby
  # bad
  arr = Array.new
  hash = Hash.new

  # good
  arr = []
  hash = {}
  ~~~


<a name="percent-w"></a>
* Prefer `%w` to the literal array syntax when you need an array of words (non-empty strings without spaces and
    special characters in them).
<sup>[[link](#percent-w)]</sup>

  ~~~ ruby
  # bad
  STATES = ['draft', 'open', 'closed']

  # good
  STATES = %w(draft open closed)
  ~~~

<a name="use-trailing-comma-in-multiline-collection-literal"></a>
* Usage of trailing comma in multi-line collection literals is encouraged. It makes diffs smaller and more meaningful.
<sup>[[link](#use-trailing-comma-in-multiline-collection-literal)]</sup>

  ~~~ ruby
  # not encouraged
  {
    foo: :bar,
    baz: :toto
  }

  # encouraged
  {
    foo: :bar,
    baz: :toto,
  }
  ~~~

<a name="percent-i"></a>
* Prefer `%i` to the literal array syntax when you need an array of symbols. Apply this rule only to arrays with two
    or more elements.
<sup>[[link](#percent-i)]</sup>

  ~~~ ruby
  # bad
  STATES = [:draft, :open, :closed]

  # good
  STATES = %i(draft open closed)
  ~~~

<a name="first-and-last"></a>
* When accessing the first or last element from an array, prefer `first` or `last` over `[0]` or `[-1]`.
<sup>[[link](#first-and-last)]</sup>

<a name="no-mutable-keys"></a>
* Avoid the use of mutable objects as hash keys.
<sup>[[link](#no-mutable-keys)]</sup>

<a name="hash-literals"></a>
* Use the Ruby 1.9 hash literal syntax when your hash keys are symbols.
<sup>[[link](#hash-literals)]</sup>

<a name="no-mixed-hash-syntax"></a>
* Don't mix the Ruby 1.9 hash syntax with hash rockets in the same hash literal. When you've got keys that are not
    symbols stick to the hash rockets syntax.
<sup>[[link](#no-mixed-hash-syntax)]</sup>

  ~~~ ruby
  # bad
  { a: 1, 'b' => 2 }

  # good
  { :a => 1, 'b' => 2 }
  ~~~

<a name="shorter-hash-query"></a>
* Use `Hash#key?` instead of `Hash#has_key?` and `Hash#value?` instead of `Hash#has_value?`. As noted
    [here](http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-core/43765) by Matz, the longer forms are considered
    deprecated.
<sup>[[link](#shorter-hash-query)]</sup>

  ~~~ ruby
  # bad
  hash.has_key?(:test)
  hash.has_value?(value)

  # good
  hash.key?(:test)
  hash.value?(value)
  ~~~

<a name="hash-fetch"></a>
* Use `Hash#fetch` when dealing with hash keys that should be present.
<sup>[[link](#hash-fetch)]</sup>

  ~~~ ruby
  heroes = { batman: 'Bruce Wayne', superman: 'Clark Kent' }
  # bad - if we make a mistake we might not spot it right away
  heroes[:batman] # => "Bruce Wayne"
  heroes[:supermann] # => nil

  # good - fetch raises a KeyError making the problem obvious
  heroes.fetch(:supermann)
  ~~~

<a name="hash-fetch-default"></a>
* Introduce default values for hash keys via `Hash#fetch` as opposed to using custom logic.
<sup>[[link](#hash-fetch-default)]</sup>

  ~~~ ruby
  batman = { name: 'Bruce Wayne', is_evil: false }

  # bad - if we just use || operator with falsy value we won't get the expected result
  batman[:is_evil] || true # => true

  # good - fetch work correctly with falsy values
  batman.fetch(:is_evil, true) # => false
  ~~~

<a name="closing-bracket"></a>
* Closing `]` and `}` must be on the line after the last element when opening brace is on a separate line from the
    first element.
<sup>[[link](#closing-bracket)]</sup>

  ~~~ ruby
  # bad
  [
    1,
    2]

  {
    a: 1,
    b: 2}

  # good
  [
    1,
    2,
  ]

  {
    a: 1,
    b: 2,
  }
  ~~~


## Strings

<a name="string-interpolation"></a>
* Prefer string interpolation and string formatting instead of string concatenation:
<sup>[[link](#string-interpolation)]</sup>

  ~~~ ruby
  # bad
  email_with_name = user.name + ' <' + user.email + '>'

  # good
  email_with_name = "#{user.name} <#{user.email}>"

  # good
  email_with_name = format('%s <%s>', user.name, user.email)
  ~~~

<a name="no-space-inside-interpolation"></a>
* With interpolated expressions, there should be no padded-spacing inside the braces.
<sup>[[link](#no-space-inside-interpolation)]</sup>

  ~~~ ruby
  # bad
  "From: #{ user.first_name }, #{ user.last_name }"

  # good
  "From: #{user.first_name}, #{user.last_name}"
  ~~~

<a name="consistent-string-quotes"></a>
* Adopt a consistent string literal quoting style.
<sup>[[link](#consistent-string-quotes)]</sup>

<a name="no-question-mark-x"></a>
* Don't use the character literal syntax `?x`. Since Ruby 1.9 it's basically redundant - `?x` would interpreted as
    `'x'` (a string with a single character in it).
<sup>[[link](#no-question-mark-x)]</sup>

<a name="curlies-interpolate"></a>
* Don't leave out `{}` around instance and global variables being interpolated into a string.
<sup>[[link](#curlies-interpolate)]</sup>

  ~~~ ruby
  class Person
    attr_reader :first_name, :last_name

    def initialize(first_name, last_name)
      @first_name = first_name
      @last_name = last_name
    end

    # bad - valid, but awkward
    def to_s
      "#@first_name #@last_name"
    end

    # good
    def to_s
      "#{@first_name} #{@last_name}"
    end
  end

  $global = 0
  # bad
  puts "$global = #$global"

  # fine, but don't use globals
  puts "$global = #{$global}"
  ~~~

<a name="no-to-s-in-interpolation"></a>
* Don't use `Object#to_s` on interpolated objects. It's invoked on them automatically.
<sup>[[link](#no-to-s-in-interpolation)]</sup>

  ~~~ ruby
  # bad
  message = "This is the #{result.to_s}."

  # good
  message = "This is the #{result}."
  ~~~

<a name="dont-abuse-gsub"></a>
* Don't use `String#gsub` in scenarios in which you can use a faster more specialized alternative.
<sup>[[link](#dont-abuse-gsub)]</sup>

  ~~~ ruby
  url = 'http://example.com'
  str = 'lisp-case-rules'

  # bad
  url.gsub('http://', 'https://')
  str.gsub('-', '_')
  str.gsub(/[aeiou]/, '')

  # good
  url.sub('http://', 'https://')
  str.tr('-', '_')
  str.delete('aeiou')
  ~~~

<a name="heredocs"></a>
* When using heredocs for multi-line strings keep in mind the fact that they preserve leading whitespace. It's a good
    practice to employ some margin based on which to trim the excessive whitespace.
<sup>[[link](#heredocs)]</sup>

  ~~~ ruby
  code = <<-END.gsub(/^\s+\|/, '')
    |def test
    |  some_method
    |  other_method
    |end
  END
  # => "def test\n  some_method\n  other_method\nend\n"

  # In Rails you can use `#strip_heredoc` to achieve the same result
  code = <<-END.strip_heredoc
    def test
      some_method
      other_method
    end
  END
  # => "def test\n  some_method\n  other_method\nend\n"
  ~~~

<a name="squiggly-heredocs"></a>
* In Ruby 2.3, prefer ["squiggly heredoc"](https://github.com/ruby/ruby/pull/878) syntax, which has the same semantics
    as `strip_heredoc` from Rails:
<sup>[[link](#squiggly-heredocs)]</sup>

  ~~~ ruby
  code = <<~END
    def test
      some_method
      other_method
    end
  END
  # => "def test\n  some_method\n  other_method\nend\n"
  ~~~


## Regular expressions

<a name="no-regexp-for-plaintext-search"></a>
* Don't use regular expressions if you just need plain text search in string: `string['text']`
<sup>[[link](#no-regexp-for-plaintext-search)]</sup>

<a name="non-capturing-regexp"></a>
* Use non-capturing groups when you don't use the captured result.
<sup>[[link](#non-capturing-regexp)]</sup>

  ~~~ ruby
  # bad
  /(first|second)/

  # good
  /(?:first|second)/
  ~~~

<a name="no-perl-regexp-last-matchers"></a>
* Don't use the cryptic Perl-legacy variables denoting last regexp group matches (`$1`, `$2`, etc). Use `Regexp#match`
    instead.
<sup>[[link](#no-perl-regexp-last-matchers)]</sup>

  ~~~ ruby
  # bad
  /(regexp)/ =~ string
  process $1

  # good
  /(regexp)/.match(string)[1]
  ~~~

<a name="no-numbered-regexes"></a>
* Avoid using numbered groups as it can be hard to track what they contain. Named groups can be used instead.
<sup>[[link](#no-numbered-regexes)]</sup>

  ~~~ ruby
  # bad
  /(regexp)/ =~ string
  ...
  process Regexp.last_match(1)

  # good
  /(?<meaningful_var>regexp)/ =~ string
  ...
  process meaningful_var
  ~~~

<a name="caret-and-dollar-regexp"></a>
* Be careful with `^` and `$` as they match start/end of line, not string endings. If you want to match the whole
    string use: `\A` and `\z` (not to be confused with `\Z` which is the equivalent of `/\n?\z/`).
<sup>[[link](#caret-and-dollar-regexp)]</sup>

  ~~~ ruby
  string = "some injection\nusername"
  string[/^username$/]   # matches
  string[/\Ausername\z/] # doesn't match
  ~~~


## Percent Literals

<a name="percent-q-shorthand"></a>
* Use `%()`(it's a shorthand for `%Q`) for single-line strings which require both interpolation and embedded
    double-quotes. For multi-line strings, prefer heredocs.
<sup>[[link](#percent-q-shorthand)]</sup>

<a name="percent-q"></a>
* Avoid `%q` unless you have a string with both `'` and `"` in it. Regular string literals are more readable and
    should be preferred unless a lot of characters would have to be escaped in them.
<sup>[[link](#percent-q)]</sup>

<a name="percent-r"></a>
* Use `%r` only for regular expressions matching *at least* one '/' character.
<sup>[[link](#percent-r)]</sup>

  ~~~ ruby
  # bad
  %r{\s+}

  # good
  %r{^/(.*)$}
  %r{^/blog/2011/(.*)$}
  ~~~

<a name="percent-s"></a>
* Avoid the use of `%s`. Use `:"some string"` to create a symbol with spaces in it.
<sup>[[link](#percent-s)]</sup>

<a name="prefer-parens-for-percent-literals"></a>
* Prefer `()` as delimiters for all `%` literals, except `%r`. Since parentheses often appear inside regular
    expressions in many scenarios a less common character like `{` might be a better choice for a delimiter, depending
    on the regexp's content.
<sup>[[link](#prefer-parens-for-percent-literals)]</sup>


## Testing

<a name="test-code-is-code"></a>
* Treat test code like any other code you write. This means: keep readability, maintainability, complexity, etc. in
    mind.
<sup>[[link](#test-code-is-code)]</sup>

<a name="minitest"></a>
* Minitest is the preferred test framework.
<sup>[[link](#minitest)]</sup>

<a name="test-one-thing"></a>
* A test case should only test a single aspect of your code.
<sup>[[link](#test-one-thing)]</sup>

<a name="test-anatomy"></a>
* A good test case consists of three parts:
<sup>[[link](#test-anatomy)]</sup>

  1.  Setup of the environment
  2.  The action that is the subject of the test
  3.  Asserting that the action did what you expect it do to.

  Consider separating these parts by a newline for readability, especially when your environment setup is complicated
  and you want to run multiple assertions afterwards.

  ~~~ ruby
  test 'sending a password reset email clears the password hash and set a reset token' do
    user = User.create!(email: 'bob@example.com')
    user.mark_as_verified

    user.send_password_reset_email

    assert_nil user.password_hash
    refute_nil user.reset_token
  end
  ~~~

<a name="small-isolated-tests"></a>
* A complex test should be split into multiple simpler tests that test functionality in isolation.
<sup>[[link](#small-isolated-tests)]</sup>

<a name="test-style"></a>
* Prefer using `test 'foo'`-style syntax to define test cases over `def test_foo`.
<sup>[[link](#test-style)]</sup>

<a name="descriptive-assertion"></a>
* Prefer using assertion methods that will yield a more descriptive error message.
<sup>[[link](#descriptive-assertion)]</sup>

  ~~~ ruby
  # bad
  assert user.valid?
  assert user.name == 'tobi'


  # good
  assert_predicate user, :valid?
  assert_equal 'tobi', user.name
  ~~~

<a name="no-assert_nothing_raised"></a>
* Avoid using `assert_nothing_raised`. Use a positive assertion instead.
<sup>[[link](#no-assert_nothing_raised)]</sup>

<a name="prefer-assertion-over-expectations"></a>
* Prefer using assertions over expectations. Expectations lead to more brittle tests, especially in combination with
    singleton objects.
<sup>[[link](#prefer-assertion-over-expectations)]</sup>

  ~~~ ruby
  # bad
  StatsD.expects(:increment).with('metric')
  do_something

  # good
  assert_statsd_increment('metric') do
    do_something
  end
  ~~~


## The rest

<a name="avoid-long-methods"></a>
* Avoid long methods.
<sup>[[link](#avoid-long-methods)]</sup>

<a name="avoid-long-parameter-lists"></a>
* Avoid long parameter lists.
<sup>[[link](#avoid-long-parameter-lists)]</sup>

<a name="avoid-needless-metaprogramming"></a>
* Avoid needless metaprogramming.
<sup>[[link](#avoid-needless-metaprogramming)]</sup>

<a name="never-start-with-get-underscore"></a>
* Never start a method with `get_`.
<sup>[[link](#never-start-with-get-underscore)]</sup>

<a name="no-bang-after-method-name"></a>
* Never use a `!` at the end of a method name if you have no equivalent method without the bang. Methods are expected
    to change internal object state; you don't need a bang for that. Bangs are to mark a more dangerous version of a
    method, e.g. `save` returns a `bool` in ActiveRecord, whereas `save!` will throw an exception on failure.
<sup>[[link](#no-bang-after-method-name)]</sup>

<a name="avoid-update_all"></a>
* Avoid using `update_all`. If you do use it, use a scoped association (`Shop.where(amount:
    nil).update_all(amount: 0)`) instead of the two-argument version (`Shop.update_all({amount: 0}, amount: nil)`). But
    seriously, you probably shouldn't be doing it in the first place.
<sup>[[link](#avoid-update_all)]</sup>

<a name="prefer-public_send"></a>
* Prefer `public_send` over `send` so as not to circumvent `private`/`protected` visibility.
<sup>[[link](#prefer-public_send)]</sup>

<a name="warning-free"></a>
* Write `ruby -w` safe code.
<sup>[[link](#warning-free)]</sup>

<a name="avoid-three-level-of-nesting-block"></a>
* Avoid more than three levels of block nesting.
<sup>[[link](#avoid-three-level-of-nesting-block)]</sup>
