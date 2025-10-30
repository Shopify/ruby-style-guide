---
layout: default
---

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
