# Ruby style guide


[Download .rubocop.yml](/rubocop.yml)

Ruby is the main language at Shopify. We are primarily a Ruby shop and we are probably one of the largest out there. Ruby is the go-to language for new web projects and scripting.

We expect all developers at Shopify to have at least a passing understanding of Ruby. It's a great language. It will make you a better developer no matter what you work in day to day. What follows is a loose coding style to follow while developing in Ruby.

## General

* Make all lines of your methods operate on the same level of abstraction. (Single Level of Abstraction Principle)
* Code in a functional way. Avoid mutation (side effects) when you can.
* Do not program defensively. (See [http://www.erlang.se/doc/programming_rules.shtml#HDR11](http://www.erlang.se/doc/programming_rules.shtml#HDR11)).
* Do not mutate arguments unless that is the purpose of the method.
* Do not mess around in core classes when writing libraries.
* Keep the code simple.
* Don't overdesign.
* Don't underdesign.
* Avoid bugs.
* Be consistent.
* Use common sense.


## Formatting


* Write your code in ASCII (or UTF-8, if you have to).
* Use 2 space indent, no tabs.
* Use Unix-style line endings.
* Use spaces around operators and after commas, colons and semicolons
* No spaces after `(`, `[` and before `]`,` )`.
* Spaces after `{` or `}` for string interpolation. (ex: `"Hello #{ world }"`)
* Indent `when` as deep as `case`.
* Use an empty line before the return value of a method (unless it only has one line), and an empty line between `def`s.
* Use empty lines to break up a long method into logical paragraphs.
* Keep lines fewer than 120 characters.
* Avoid trailing whitespace.
* Files should end with a new line
* `end` should always align with the beginning of the line that started the block or method.
* Multi line hashes are indented like everything else with 2 spaces. `}` gets its own line.
* code blocks behind a ```||= begin``` are still normal code blocks and should be indented with two spaces and a matching end on it's own line.


## Syntax

* Use `def` with parentheses when there are arguments.
* Never use `for`, unless you know exactly why, in .rb files.
* Never use `then`.
* Use `when x; ...` for one-line cases.
* Use `&&/||` for boolean expressions, `and/or` for control flow. (Rule of thumb: if you have to use outer parentheses, you are using the wrong operators.) See http://devblog.avdi.org/2014/08/26/how-to-use-rubys-english-andor-operators-without-going-nuts/
* Avoid multiline `?:`, use `if`.
* Suppress superfluous parentheses when calling class methods.
```ruby

    has_many :variants
```
but

```ruby
    x = Math.sin(y)
    array.delete(e)
```
* Prefer `{...}` over `do...end`.  Multiline `{...}` is fine in exceptional cases: having different statement endings (`}` for blocks, `end` for `if/while/...`) makes it easier to see what ends where.  But use `do...end` for control flow and method definitions (e.g. in Rakefiles and certain DSLs).  Avoid `do...end` when chaining.
* Avoid `return` where not required.
* Avoid line continuation (`\`).
* Using the return value of `=` is okay:
```ruby
    if v = /foo/.match(string) ...
```
* Use `||=` freely.
* Use non-OO regexps (they won't make the code better).  Freely use `=~`, `$0-9`, `$~`, `$\` and `$'` when needed.
* Prefer keyword arguments over options hash.


## Naming

* Use snake_case for methods.
* Use CamelCase for classes and modules.  (Keep acronyms like HTTP, RFC, XML uppercase.)
* Use SCREAMING_SNAKE_CASE for other constants.
* Use _ or names prefixed with _ for unused variables.
* When using inject with short blocks, name the arguments according to what is being injected, e.g. `|hash, e|` (mnemonic: hash, element)
* When defining binary operators, name the argument `other`.
* Prefer `map` over `collect`, `find` over `detect`, `select` over `find_all`, `size` over `length`.
* The names of predicate methods (methods that return a boolean value) should end in a question mark. (i.e. `Array#empty?`). Methods that don't return a boolean, shouldn't end in a question mark.

## Comments

* Comments longer than a word are capitalized and use punctuation.
* Avoid superfluous comments.
* If you really need them, could you instead clarify your code?

## The rest

* Prefer using `hash.fetch(:key)` over `hash[:key]` when you expect `:key` to be set. This will lead to better error messages and stack traces when it isn't. ([longer rationale](http://www.bitzesty.com/blog/2014/5/19/hashfetch-in-ruby-development))
* Prefer using `hash.fetch(:key, nil)` over `hash[:key]` when `:key` may not be set and `nil` is the default value you want to use in that case.
* Avoid using modules whenever possible, especially if it is only used in one place. If you really need to encapsulate the code you should be creating a class.
* Avoid hashes-as-optional-parameters in general.  Does the method do too much?
* Avoid long methods.
* Avoid long parameter lists.
* Use `def self.method` to define singleton methods.
* Avoid `alias` when `alias_method` will do.
* Avoid needless metaprogramming.
* Never start a method with `get_`
* Never use a `!` at the end of a method name if you have no equivalent method without the bang. Methods are expected to change internal object state; you don't need a bang for that. Bangs are to mark a more dangerous version of a method, e.g. `save` returns a `bool` in ActiveRecord, whereas `save!` will throw an exception on failure.
* Avoid using `rescue nil`. It swallows all errors, including syntax errors, and makes them hard to track down.
* Avoid using `update_all`. If you do use it, use a scoped association (`Shop.where(amount: nil).update_all(amount: 0)`) instead of the two-argument version (`Shop.update_all({amount: 0}, amount: nil)`). But seriously, you probably shouldn't be doing it in the first place.
* Avoid using `flunk` if an `assert_*` or `refute_*` family method will suffice.
* Avoid using `refute_*` if an `assert_*` can do.

## Editor integration

### Emacs

[rubocop.el](https://github.com/bbatsov/rubocop-emacs) is a simple
Emacs interface for RuboCop. It allows you to run RuboCop inside Emacs
and quickly jump between problems in your code.

[flycheck](https://github.com/lunaryorn/flycheck) > 0.9 also supports
RuboCop and uses it by default when available.

### Vim

The [vim-rubocop](https://github.com/ngmy/vim-rubocop) plugin runs
RuboCop and displays the results in Vim.

There's also a RuboCop checker in
[syntastic](https://github.com/scrooloose/syntastic).

### Sublime Text

If you're a ST user you might find the
[Sublime RuboCop plugin](https://github.com/pderichs/sublime_rubocop)
useful.

### TextMate2

The [textmate2-rubocop](https://github.com/mrdougal/textmate2-rubocop)
bundle displays formatted RuboCop results in a new window.
Installation instructions can be found [here](https://github.com/mrdougal/textmate2-rubocop#installation).

### Atom

The [atom-lint](https://github.com/yujinakayama/atom-lint) package
runs RuboCop and highlights the offenses in Atom.

You can also use the [linter-rubocop](https://github.com/AtomLinter/linter-rubocop)
plugin for Atom's [linter](https://github.com/AtomLinter/Linter).

## Git pre-commit hook integration

[overcommit](https://github.com/brigade/overcommit) is a fully configurable and
extendable Git commit hook manager. To use RuboCop with overcommit, add the
following to your `.overcommit.yml` file:

```yaml
PreCommit:
  RuboCop:
    enabled: true
```
